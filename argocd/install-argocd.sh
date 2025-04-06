#!/bin/bash

# Install Argo CD in the cluster
echo "Installing Argo CD in the cluster..."

# Create namespace
kubectl create namespace argocd

# Apply Argo CD installation manifest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for all Argo CD components to be ready
echo "Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# Patch the Argo CD service to use LoadBalancer (for easy access)
echo "Exposing Argo CD API server..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Retrieve the initial admin password
echo "Retrieving initial admin password..."
ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Initial admin password: $ADMIN_PASSWORD"
echo "Username: admin"

# Print access information
echo "Argo CD UI should be available soon at: http://localhost:8080 (after port-forwarding)"
echo "To access Argo CD UI, run: kubectl port-forward svc/argocd-server -n argocd 8080:443"

echo "Argo CD installation completed!" 