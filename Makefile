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

login-acr: login
	az acr login --name ${AZURE_CONTAINER_REGISTRY}

# Build the Docker image
docker-build:
	docker buildx build --no-cache --platform linux/amd64 -t $(IMAGE_NAME) --load .

docker-tag:
	docker tag $(IMAGE_NAME) $(FULL_IMAGE_LATEST)
	docker tag $(IMAGE_NAME) $(FULL_IMAGE_TAG)

# Push to registry
docker-push: login-acr
	docker push --all-tags $(REGISTRY)/$(IMAGE_NAME)

# Build and push in one command
docker-deploy: docker-build docker-tag docker-push

# For managing the database locally
start-db:
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env up -d filmdatahub-database

stop-db:
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env down filmdatahub-database

destroy-db:
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env down -v filmdatahub-database

makemigrations:
	python mysite/manage.py makemigrations --settings=mysite.settings_local

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

# Deploy to Kubernetes
k8s-build:
	kubectl create secret generic filmdatahub-secret --from-literal=DATABASE_PASSWORD=${DATABASE_PASSWORD}
	kubectl apply -f kubernetes/migration.yaml
	kubectl wait --for=condition=complete job/filmdatahub-migration
	kubectl logs job/filmdatahub-migration
	kubectl apply -f kubernetes/deployment.yaml
	kubectl rollout status deployment/filmdatahub

k8s-clean:
	kubectl delete secret filmdatahub-secret --ignore-not-found
	kubectl delete job filmdatahub-migration --ignore-not-found
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

# Development workflow commands
dev-make-migrations:
	cd mysite && python manage.py makemigrations --settings=mysite.settings_local

dev-migrate:
	cd mysite && python manage.py migrate --settings=mysite.settings_local

dev-workflow:
	./scripts/dev-workflow.sh

# Check migration status
check-migrations:
	cd mysite && python manage.py showmigrations --settings=mysite.settings_local