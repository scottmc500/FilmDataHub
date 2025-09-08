#!/bin/bash

# FilmDataHub Docker Push Script

set -e

REGISTRY="filmdatahubregistry.azurecr.io"
IMAGE_NAME="filmdatahub"
TAG="latest"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${TAG}"

# Check if already logged in, if not, prompt for manual login
if ! az account show &> /dev/null; then
    echo "Not logged into Azure. Please run 'az login' manually first."
    echo "Or set these environment variables for service principal authentication:"
    echo "  export AZURE_CLIENT_ID=your-client-id"
    echo "  export AZURE_CLIENT_SECRET=your-client-secret"
    echo "  export AZURE_TENANT_ID=your-tenant-id"
    echo "  export AZURE_SUBSCRIPTION_ID=your-subscription-id"
    exit 1
fi

echo "Already logged into Azure. Proceeding with ACR login..."
az acr login --name filmdatahubregistry

echo "Pushing Docker image: ${FULL_IMAGE}"
docker push "${FULL_IMAGE}"

echo "Push completed successfully!"
