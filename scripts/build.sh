#!/bin/bash

# FilmDataHub Docker Build Script

set -e

REGISTRY="filmdatahubregistry.azurecr.io"
IMAGE_NAME="filmdatahub"
TAG="latest"
FULL_IMAGE="${REGISTRY}/${IMAGE_NAME}:${TAG}"

echo "Building Docker image: ${FULL_IMAGE}"

docker buildx build \
  --no-cache \
  --platform linux/amd64,linux/arm64 \
  -t "${FULL_IMAGE}" \
  --load \
  mysite

echo "Build completed successfully!"
