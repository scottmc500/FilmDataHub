# FilmDataHub Docker Commands

# Variables
REGISTRY = filmdatahubregistry.azurecr.io
IMAGE_NAME = filmdatahub
TAG = latest
FULL_IMAGE = $(REGISTRY)/$(IMAGE_NAME):$(TAG)

# Build the Docker image
build:
	docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t $(FULL_IMAGE) --load mysite

# Push to registry
push: login
	docker push $(FULL_IMAGE)

# Login to Azure Container Registry
login:
	@if ! az account show &> /dev/null; then \
		echo "Not logged into Azure. Please run 'az login' manually first."; \
		echo "Or use 'make login-sp' for service principal authentication."; \
		exit 1; \
	fi
	az acr login --name filmdatahubregistry

# Login with service principal (set env vars: AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID)
login-sp:
	@if [[ -z "$$AZURE_CLIENT_ID" || -z "$$AZURE_CLIENT_SECRET" || -z "$$AZURE_TENANT_ID" ]]; then \
		echo "Error: Service principal environment variables not set."; \
		echo "Set: AZURE_CLIENT_ID, AZURE_CLIENT_SECRET, AZURE_TENANT_ID"; \
		exit 1; \
	fi
	az login --service-principal --username $$AZURE_CLIENT_ID --password $$AZURE_CLIENT_SECRET --tenant $$AZURE_TENANT_ID
	az acr login --name filmdatahubregistry

# Build and push in one command
deploy: build push

# Clean up local images
clean:
	docker rmi $(FULL_IMAGE) || true

# Quick development build (single platform)
build-dev:
	docker build -t $(FULL_IMAGE) mysite

# Deploy to Kubernetes
k8s-deploy:
	kubectl apply -f azure/manifest.yaml
	kubectl rollout restart deployment filmdatahub

# Full deployment pipeline
deploy-all: deploy k8s-deploy

# Show logs
logs:
	kubectl logs -f deployment/filmdatahub

# Show pod status
status:
	kubectl get pods
