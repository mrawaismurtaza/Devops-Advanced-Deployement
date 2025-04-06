#!/bin/bash

# Download Istio
ISTIO_VERSION=1.18.0
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} sh -

# Add istioctl to PATH
cd istio-${ISTIO_VERSION}
export PATH=$PWD/bin:$PATH

# Install Istio with demo profile (includes core components and minimal resources)
istioctl install --set profile=demo -y

# Enable automatic sidecar injection for namespaces
kubectl label namespace dev istio-injection=enabled
kubectl label namespace prod istio-injection=enabled

# Install Kiali, Prometheus, Grafana, and other addons for observability
kubectl apply -f samples/addons

# Wait for services to be ready
echo "Waiting for Istio services to be ready..."
kubectl -n istio-system wait --for=condition=available --timeout=300s deployment/istiod
kubectl -n istio-system wait --for=condition=available --timeout=300s deployment/istio-ingressgateway

echo "Istio installation completed!"
