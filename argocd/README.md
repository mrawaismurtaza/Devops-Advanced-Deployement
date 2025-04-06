# GitOps with Argo CD

This directory contains configuration files and scripts for implementing GitOps with Argo CD in the DevOps Advanced Deployment project.

## Table of Contents

- [Overview](#overview)
- [Setup Instructions](#setup-instructions)
- [Using Argo CD](#using-argo-cd)
- [Automated Sync](#automated-sync)
- [Rollback Mechanism](#rollback-mechanism)
- [Troubleshooting](#troubleshooting)

## Overview

Argo CD is a declarative GitOps continuous delivery tool for Kubernetes. It follows the GitOps pattern where the desired state of the application is defined in Git and Argo CD ensures that the actual state in the cluster matches this desired state.

In this project, we use Argo CD to:
1. Automatically deploy applications from Git to Kubernetes
2. Maintain synchronization between Git and the cluster
3. Provide rollback capabilities for failed deployments

## Setup Instructions

### 1. Install Argo CD in your Kubernetes cluster

```bash
# Make the installation script executable
chmod +x install-argocd.sh

# Run the installation script
./install-argocd.sh
```

This will:
- Create an `argocd` namespace
- Install Argo CD components
- Expose the Argo CD server
- Retrieve the initial admin password

### 2. Access the Argo CD UI

```bash
# Port-forward the Argo CD server
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Then visit http://localhost:8080 in your browser and log in with:
- Username: admin
- Password: (provided by the installation script)

### 3. Install Argo CD CLI (Optional)

```bash
# Download Argo CD CLI
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# Login to Argo CD
argocd login localhost:8080
```

## Using Argo CD

### Deploy the Application

```bash
# Apply the Application manifest
kubectl apply -f application.yaml
```

This will create an Argo CD Application resource that points to your Git repository and starts synchronizing resources to your cluster.

> **Note**: Make sure to update the `repoURL` in `application.yaml` to point to your actual GitHub repository URL before applying.

## Automated Sync

Argo CD will automatically synchronize your application when:

1. Changes are detected in the Git repository
2. The Application was created with `automated` sync policy (this is configured in our `application.yaml`)

The configuration enables:
- `prune: true` - Resources that no longer exist in Git will be deleted
- `selfHeal: true` - Resources that drift from the desired state will be reconciled
- `CreateNamespace: true` - Target namespaces will be automatically created if they don't exist

## Rollback Mechanism

If a deployment fails (e.g., due to a broken image tag), you can use the rollback script to revert to a previous successful version:

```bash
# Make the rollback script executable
chmod +x rollback.sh

# Run the rollback utility
./rollback.sh devops-advanced-deployment
```

The script provides options to:
1. View revision history
2. Rollback to a specific revision
3. Simulate a failed deployment (for testing)

## Troubleshooting

Common issues and solutions:

1. **Application not syncing**:
   ```bash
   argocd app get devops-advanced-deployment
   argocd app sync devops-advanced-deployment
   ```

2. **Sync errors**:
   - Check the application logs: `argocd app logs devops-advanced-deployment`
   - Validate manifests: `argocd app manifests devops-advanced-deployment | kubectl apply --dry-run=client -f -`

3. **Access issues**:
   - Ensure you have the correct permissions in the cluster
   - Verify that Argo CD can access your Git repository (SSH key or access token might be needed) 