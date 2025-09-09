# FilmDataHub Docker Commands

# Variables
REGISTRY = ${AZURE_CONTAINER_REGISTRY}.azurecr.io
IMAGE_NAME = filmdatahub
TAG = latest
FULL_IMAGE = $(REGISTRY)/$(IMAGE_NAME):$(TAG)

set-env:
	set -a && source mysite/.env && set +a

# Login to Azure Container Registry
login:
	az login --service-principal --username ${AZURE_CLIENT_ID} --password ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}

login-acr: login
	az acr login --name ${AZURE_CONTAINER_REGISTRY}

# Build the Docker image
docker-build:
	docker buildx build --no-cache --platform linux/amd64 -t $(FULL_IMAGE) --load mysite

# Push to registry
docker-push: login-acr
	docker push $(FULL_IMAGE)

# Build and push in one command
docker-deploy: docker-build docker-push

run-local: docker-build
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env up -d

destroy-local:
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env down -v
	docker rmi $(FULL_IMAGE)

k8s-get-context:
	az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${AZURE_CLUSTER_NAME}

# Deploy to Kubernetes
k8s-build:
	kubectl create secret generic filmdatahub-secret --from-literal=DATABASE_PASSWORD=${DATABASE_PASSWORD}
	kubectl apply -f kubernetes/migration.yaml
	kubectl wait --for=condition=complete job/filmdatahub-migration --timeout=300s
	kubectl apply -f kubernetes/deployment.yaml
	kubectl rollout status deployment/filmdatahub

k8s-clean:
	kubectl delete secret filmdatahub-secret --ignore-not-found
	kubectl delete -f kubernetes/migration.yaml --ignore-not-found
	kubectl delete -f kubernetes/deployment.yaml --ignore-not-found

k8s-deploy: k8s-get-context k8s-clean k8s-build

# Full deployment pipeline
deploy-all: docker-deploy k8s-deploy

# Show logs
logs:
	kubectl logs -f deployment/filmdatahub -c filmdatahub

# Show pod status
status:
	kubectl get pods