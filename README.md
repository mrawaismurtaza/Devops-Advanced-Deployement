# Devops-Advanced-Deployement
Advanced Deployment Strategies with Kubernetes, Helm, Service Mesh, and GitOps
<<<<<<< Updated upstream
=======

## Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Running the Application](#running-the-application)
- [Kubernetes Deployment Instructions](#kubernetes-deployment-instructions)
- [Service Mesh Setup and Traffic Management](#service-mesh-setup-and-traffic-management)
- [GitOps Workflow](#gitops-workflow)
- [Security Practices](#security-practices)
- [Troubleshooting](#troubleshooting)
- [Additional Resources](#additional-resources)

## Overview

This project demonstrates advanced deployment techniques in a Kubernetes environment, including:

- Multi-environment deployment using Helm charts
- Service mesh implementation with Istio for traffic management
- GitOps workflow for continuous deployment
- Modern security practices

The application consists of a React frontend and Node.js/Express backend with MongoDB for persistence.

## Project Structure

```
devops-app/                   # Helm chart for Kubernetes deployment
├── templates/                # Kubernetes resource templates
├── values.yaml              # Default configuration values
├── values-dev.yaml          # Development environment values
└── values-prod.yaml         # Production environment values

kubectl-files/                # Raw Kubernetes manifests
├── backend.yaml             # Backend deployment with v1 label
├── config.yaml              # ConfigMap and Secret resources
├── deployment.yaml          # Combined deployments
├── frontend.yaml            # Frontend deployment
├── ingress.yaml             # Ingress configuration
└── namespaces.yaml          # Namespace definitions

service-mesh/                 # Istio service mesh configuration
├── access-dashboards.sh     # Script to open Istio dashboards
├── backend-v2.yaml          # Backend v2 deployment for traffic splitting
├── destination-rule.yaml    # Defines service subsets for traffic management
├── gateway.yaml             # Istio gateway configuration
├── install-istio.sh         # Istio installation script
├── peer-authentication.yaml # mTLS configuration
└── virtual-service.yaml     # Traffic routing rules

frontend/                     # React frontend application
├── public/                  # Static files
├── src/                     # Source code
│   ├── App.js              # Main application component
│   └── App.css             # Styles
├── Dockerfile               # Frontend container definition
└── package.json             # Dependencies and scripts

backend/                      # Node.js/Express backend application
├── server.js                # Backend server implementation
├── Dockerfile               # Backend container definition
└── package.json             # Dependencies and scripts

.github/workflows/            # GitHub Actions CI/CD pipeline
└── ci.yml                   # Continuous integration workflow
```

## Running the Application

### Prerequisites

- Node.js 14+ and npm
- Docker and Docker Compose
- MongoDB (local instance or connection string)

### Running Backend Locally

```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Set environment variables
export MONGO_URI="mongodb+srv://<username>:<password>@<cluster>/<database>"

# Start the backend service
npm start

# The backend will be available at http://localhost:5000
```

### Running Frontend Locally

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Start the frontend development server
npm start

# The frontend will be available at http://localhost:3000
```

### Running with Docker Compose

For a complete local environment including backend, frontend, and MongoDB:

```bash
# Build and start all services
docker-compose up --build

# Access frontend at http://localhost:4000
# Access backend at http://localhost:5000
```

### Environment Variables

Backend:

- `MONGO_URI`: MongoDB connection string

Frontend:

- `REACT_APP_API_URL`: Backend API URL (defaults to http://localhost:5000)

## Kubernetes Deployment Instructions

### Prerequisites

- Kubernetes cluster (Minikube, kind, or cloud provider)
- kubectl configured to connect to your cluster
- Helm 3.x installed

### Step 1: Create Namespaces

```bash
kubectl apply -f kubectl-files/namespaces.yaml
```

### Step 2: Deploy with Helm

For development environment:

```bash
helm install myapp ./devops-app -f devops-app/values-dev.yaml
```

For production environment:

```bash
helm install myapp ./devops-app -f devops-app/values-prod.yaml
```

### Step 3: Verify Deployment

```bash
kubectl get pods -n dev  # Or -n prod for production
kubectl get services -n dev
kubectl get ingress -n dev
```

## Service Mesh Setup and Traffic Management

### Installing Istio

```bash
# Make the installation script executable
chmod +x service-mesh/install-istio.sh

# Run the installation script
./service-mesh/install-istio.sh
```

### Configure Traffic Splitting

The service mesh is configured to split traffic between backend versions:

- 90% of traffic goes to backend v1
- 10% of traffic goes to backend v2

```bash
# Apply destination rules for defining service subsets
kubectl apply -f service-mesh/destination-rule.yaml

# Apply virtual service for traffic splitting
kubectl apply -f service-mesh/virtual-service.yaml
```

### Accessing Service Mesh Dashboards

```bash
# Make the script executable
chmod +x service-mesh/access-dashboards.sh

# Run the script to open dashboards
./service-mesh/access-dashboards.sh
```

This will open:

- Kiali for service topology visualization
- Grafana for metrics visualization
- Prometheus for metrics storage
- Jaeger for distributed tracing

## GitOps Workflow

This project follows GitOps principles:

1. **Git as Single Source of Truth**: All configuration is versioned in this repository
2. **Declarative Infrastructure**: Using Kubernetes manifests and Helm charts
3. **Automated Synchronization**: CI/CD pipeline automatically applies changes

### CI/CD Pipeline Flow:

1. Code changes are pushed to the repository
2. GitHub Actions workflow builds Docker images
3. Images are pushed to Docker Hub
4. Kubernetes manifests are updated with new image versions
5. Changes are applied to the cluster

### Argo CD Implementation

Argo CD is implemented to automate continuous delivery following GitOps principles. See the `argocd` directory for detailed implementation. Key features include:

- **Automated Sync**: Changes in Git repository are automatically applied to the cluster
- **Rollback Capability**: Any failed deployment can be easily rolled back
- **Multi-Environment Support**: Different configuration for dev/prod environments

To set up Argo CD:

```bash
# Navigate to argocd directory
cd argocd

# Install Argo CD in your cluster
./install-argocd.sh

# Access Argo CD UI
./access-argocd.sh
```

Once set up, Argo CD will:
1. Monitor your Git repository for changes
2. Automatically apply changes to the Kubernetes cluster
3. Enforce desired state by reconciling any drift

For rolling back failed deployments:
```bash
./rollback.sh devops-advanced-deployment
```

## Security Practices

### Secrets Management

Sensitive information like database credentials are stored securely:

1. **Kubernetes Secrets**: Database credentials stored as Kubernetes Secrets

   ```bash
   # Example in Helm values
   kubectl apply -f kubectl-files/config.yaml
   ```

2. **Environment-Specific Secrets**: Different secrets for dev and prod environments
   ```yaml
   # Example from values-dev.yaml and values-prod.yaml
   mongoUri: mongodb+srv://user:password@cluster.mongodb.net/mydatabase
   ```

### Mutual TLS (mTLS)

Service-to-service communication is secured with mTLS using Istio:

1. **Enforcing mTLS**: All service communication requires mutual authentication

   ```bash
   kubectl apply -f service-mesh/peer-authentication.yaml
   ```

2. **TLS Configuration**: Destination rules specify ISTIO_MUTUAL as the TLS mode
   ```yaml
   # From destination-rule.yaml
   trafficPolicy:
     tls:
       mode: ISTIO_MUTUAL
   ```

### Additional Security Measures

1. **Network Policies**: Restricting pod-to-pod communication
2. **Resource Limits**: Preventing DoS attacks by limiting resource usage
3. **Readiness/Liveness Probes**: Ensuring application health

## Troubleshooting

### Common Issues

1. **kubectl connection errors**:

   - Ensure your Kubernetes cluster is running: `minikube status` or `kubectl cluster-info`
   - Verify kubectl context: `kubectl config current-context`

2. **Service mesh issues**:

   - Check Istio installation: `istioctl verify-install`
   - Verify sidecar injection: `kubectl -n dev get pods -L istio-injection`

3. **MongoDB connection problems**:

   - Verify MongoDB URI in secrets: `kubectl -n dev get secret app-secret -o yaml`
   - Check network policies allow database connection

4. **Local development errors**:
   - Clear browser cache and node_modules: `rm -rf node_modules && npm install`
   - Verify environment variables are set correctly

### Viewing Logs

```bash
# View backend logs
kubectl logs -n dev -l app=backend

# View frontend logs
kubectl logs -n dev -l app=frontend

# Stream logs with follow flag
kubectl logs -n dev -l app=backend -f
```

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Istio Documentation](https://istio.io/latest/docs/)
>>>>>>> Stashed changes
