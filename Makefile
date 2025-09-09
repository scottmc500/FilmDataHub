# FilmDataHub Docker Commands

# Variables
REGISTRY = filmdatahubregistry.azurecr.io
IMAGE_NAME = filmdatahub
TAG = latest
FULL_IMAGE = $(REGISTRY)/$(IMAGE_NAME):$(TAG)

# Login to Azure Container Registry
login:
	@if ! az account show &> /dev/null; then \
		echo "Not logged into Azure. Please run 'az login' manually first."; \
		exit 1; \
	fi
	az acr login --name filmdatahubregistry

# Build the Docker image
docker-build:
	docker buildx build --no-cache --platform linux/amd64 -t $(FULL_IMAGE) --load mysite

# Push to registry
docker-push: login
	docker push $(FULL_IMAGE)

# Build and push in one command
docker-deploy: docker-build docker-push

# Clean up local images
docker-clean:
	docker rmi $(FULL_IMAGE)

run-local: docker-build
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env up -d

destroy-local:
	docker compose -f mysite/docker-compose.yaml --env-file mysite/.env down -v
	docker rmi $(FULL_IMAGE)


# Deploy to Kubernetes
k8s-build:
	kubectl apply -f kubernetes/migration.yaml
	kubectl wait --for=condition=complete job/filmdatahub-migration --timeout=300s
	kubectl apply -f kubernetes/deployment.yaml
	kubectl rollout status deployment/filmdatahub

k8s-clean:
	kubectl delete job/filmdatahub-migration --ignore-not-found
	kubectl delete deployment/filmdatahub --ignore-not-found

k8s-deploy: login k8s-clean k8s-build

# Full deployment pipeline
deploy-all: docker-deploy k8s-deploy

# Show logs
logs:
	kubectl logs -f deployment/filmdatahub -c filmdatahub

# Show pod status
status:
	kubectl get pods