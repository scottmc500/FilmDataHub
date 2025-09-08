#!/bin/bash

# FilmDataHub Docker Push Script with Service Principal Support

set -e

REGISTRY="filmdatahubregistry.azurecr.io"
IMAGE_NAME="filmdatahub"
TAG="latest"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${TAG}"

# Check for service principal environment variables
if [[ -n "$AZURE_CLIENT_ID" && -n "$AZURE_CLIENT_SECRET" && -n "$AZURE_TENANT_ID" ]]; then
    echo "Using service principal authentication..."
    az login --service-principal \
        --username "$AZURE_CLIENT_ID" \
        --password "$AZURE_CLIENT_SECRET" \
        --tenant "$AZURE_TENANT_ID"
    
    if [[ -n "$AZURE_SUBSCRIPTION_ID" ]]; then
        az account set --subscription "$AZURE_SUBSCRIPTION_ID"
    fi
else
    # Check if already logged in with interactive login
    if ! az account show &> /dev/null; then
        echo "Not logged into Azure. Please run 'az login' manually first."
        echo "Or set these environment variables for service principal authentication:"
        echo "  export AZURE_CLIENT_ID=your-client-id"
        echo "  export AZURE_CLIENT_SECRET=your-client-secret"
        echo "  export AZURE_TENANT_ID=your-tenant-id"
        echo "  export AZURE_SUBSCRIPTION_ID=your-subscription-id"
        exit 1
    fi
fi

echo "Logging into Azure Container Registry..."
az acr login --name filmdatahubregistry

echo "Pushing Docker image: ${FULL_IMAGE}"
docker push "${FULL_IMAGE}"

echo "Push completed successfully!"
