#!/bin/bash

# FilmDataHub Full Deployment Script

set -e

echo "Starting full deployment..."

# Build the image
echo "Step 1: Building Docker image..."
./scripts/build.sh

# Push the image
echo "Step 2: Pushing to registry..."
./scripts/push.sh

# Deploy to Kubernetes
echo "Step 3: Deploying to Kubernetes..."
kubectl apply -f azure/manifest.yaml
kubectl rollout restart deployment filmdatahub

echo "Deployment completed successfully!"
echo "Check status with: kubectl get pods"
