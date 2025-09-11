# FilmDataHub Docker Commands

# Variables
REGISTRY = ${AZURE_CONTAINER_REGISTRY}.azurecr.io
IMAGE_NAME = filmdatahub
TAG = ${DOCKER_IMAGE_TAG}
FULL_IMAGE_LATEST = $(REGISTRY)/$(IMAGE_NAME):latest
FULL_IMAGE_TAG = $(REGISTRY)/$(IMAGE_NAME):$(TAG)

# Login to Azure Container Registry
login:
	az login --service-principal --username ${AZURE_CLIENT_ID} --password ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}

login-registry: login
	az acr login --name ${AZURE_CONTAINER_REGISTRY}

# Terraform Commands
terraform-init:
	terraform -chdir=azure init
	
terraform-validate:
	terraform -chdir=azure validate
	
terraform-plan:
	terraform -chdir=azure plan -out=tfplan -var "db_admin_username=${DATABASE_USERNAME}" -var "db_admin_password=${DATABASE_PASSWORD}"
	
terraform-apply:
	terraform -chdir=azure apply tfplan
	

# Build the Docker image
docker-build:
	docker buildx build --no-cache --platform linux/amd64 -t $(IMAGE_NAME) --load .

docker-tag:
	docker tag $(IMAGE_NAME) $(FULL_IMAGE_LATEST)
	docker tag $(IMAGE_NAME) $(FULL_IMAGE_TAG)

# Push to registry
docker-push: login-registry
	docker push --all-tags $(REGISTRY)/$(IMAGE_NAME)

# For running the application locally
run-local: docker-build
	docker compose up -d

stop-local:
	docker compose down

destroy-local:
	docker compose down -v
	docker rmi $(IMAGE_NAME)

k8s-get-context:
	az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_CLUSTER_NAME}

k8s-clean:
	kubectl delete secret filmdatahub-secret --ignore-not-found
	kubectl delete job filmdatahub-migration --ignore-not-found
	kubectl delete -f kubernetes/deployment.yaml --ignore-not-found

# Deploy to Kubernetes
k8s-build:
	kubectl create secret generic filmdatahub-secret \
	--from-literal=DATABASE_USERNAME=${DATABASE_USERNAME} \
	--from-literal=DATABASE_PASSWORD=${DATABASE_PASSWORD}
	kubectl apply -f kubernetes/migration.yaml
	kubectl wait --for=condition=complete job/filmdatahub-migration --timeout=5m
	kubectl logs job/filmdatahub-migration
	kubectl apply -f kubernetes/deployment.yaml
	kubectl rollout status deployment/filmdatahub