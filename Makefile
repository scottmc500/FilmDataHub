# Variables
FULL_IMAGE_NO_TAG = ${CONTAINER_REGISTRY}/filmdatahub
FULL_IMAGE_LATEST = $(FULL_IMAGE_NO_TAG):latest
FULL_IMAGE_TAG = $(FULL_IMAGE_NO_TAG):${DOCKER_IMAGE_TAG}

# Cloud-agnostic login commands
login:
	@if [ "${CLOUD_PROVIDER}" = "azure" ]; then \
		az login --service-principal --username ${AZURE_CLIENT_ID} --password ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}; \
	elif [ "${CLOUD_PROVIDER}" = "aws" ]; then \
		aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}; \
		aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}; \
		aws configure set default.region ${AWS_DEFAULT_REGION}; \
	else \
		echo "Error: CLOUD_PROVIDER must be set to 'azure' or 'aws'"; \
		exit 1; \
	fi

login-registry: login
	@if [ "${CLOUD_PROVIDER}" = "azure" ]; then \
		az acr login --name ${CONTAINER_REGISTRY}; \
	elif [ "${CLOUD_PROVIDER}" = "aws" ]; then \
		aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${CONTAINER_REGISTRY}; \
	else \
		echo "Error: CLOUD_PROVIDER must be set to 'azure' or 'aws'"; \
		exit 1; \
	fi

# Terraform Commands
terraform-init:
	terraform -chdir=${CLOUD_PROVIDER} init
	
terraform-validate:
	terraform -chdir=${CLOUD_PROVIDER} validate
	
terraform-plan:
	terraform -chdir=${CLOUD_PROVIDER} plan -out=tfplan -var "db_admin_username=${DATABASE_USERNAME}" -var "db_admin_password=${DATABASE_PASSWORD}"
	
terraform-apply:
	terraform -chdir=${CLOUD_PROVIDER} apply tfplan

terraform-destroy:
	terraform -chdir=${CLOUD_PROVIDER} destroy

# Build the Docker image
docker-build:
	docker buildx build --no-cache --platform linux/amd64 -t filmdatahub --load .

docker-tag:
	docker tag filmdatahub $(FULL_IMAGE_LATEST)
	docker tag filmdatahub $(FULL_IMAGE_TAG)

# Push to registry
docker-push: login-registry
	docker push --all-tags $(FULL_IMAGE_NO_TAG)

# For running the application locally
run-local: docker-build
	docker compose up -d

stop-local:
	docker compose down

destroy-local:
	docker compose down -v
	docker rmi filmdatahub

k8s-get-context:
	@if [ "${CLOUD_PROVIDER}" = "azure" ]; then \
		az aks get-credentials --resource-group ${AZURE_RESOURCE_GROUP} --name ${K8S_CLUSTER_NAME}; \
	elif [ "${CLOUD_PROVIDER}" = "aws" ]; then \
		aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ${K8S_CLUSTER_NAME}; \
	else \
		echo "Error: CLOUD_PROVIDER must be set to 'azure' or 'aws'"; \
		exit 1; \
	fi

k8s-clean:
	kubectl delete secret filmdatahub-secret --ignore-not-found
	kubectl delete job filmdatahub-migration --ignore-not-found
	kubectl delete -f ${CLOUD_PROVIDER}/deployment.yaml --ignore-not-found

# Deploy to Kubernetes
k8s-build:
	kubectl create secret generic filmdatahub-secret \
	--from-literal=DATABASE_USERNAME=${DATABASE_USERNAME} \
	--from-literal=DATABASE_PASSWORD=${DATABASE_PASSWORD}
	kubectl apply -f ${CLOUD_PROVIDER}/migration.yaml
	kubectl wait --for=condition=complete job/filmdatahub-migration --timeout=5m
	kubectl logs job/filmdatahub-migration
	kubectl apply -f ${CLOUD_PROVIDER}/deployment.yaml
	kubectl rollout status deployment/filmdatahub