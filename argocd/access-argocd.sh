#!/bin/bash

# Script to simplify Argo CD access

# Function to get Argo CD admin password
get_admin_password() {
    echo "Retrieving Argo CD admin password..."
    ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo "Admin password: $ARGOCD_PASSWORD"
    echo "Username: admin"
}

# Function to set up port forwarding
setup_port_forwarding() {
    echo "Setting up port forwarding to Argo CD server..."
    echo "Access the Argo CD UI at: http://localhost:8080"
    echo "To stop port forwarding, press Ctrl+C"
    kubectl port-forward svc/argocd-server -n argocd 8080:443
}

# Function to login to Argo CD CLI
cli_login() {
    echo "Logging in to Argo CD CLI..."
    ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    argocd login localhost:8080 --username admin --password "$ARGOCD_PASSWORD" --insecure
    
    # Test connection
    if argocd cluster list &>/dev/null; then
        echo "Login successful. You can now use the Argo CD CLI."
    else
        echo "Login failed. Please make sure port forwarding is active in another terminal."
    fi
}

# Main menu
echo "========================================"
echo "Argo CD Access Utility"
echo "========================================"
echo ""
echo "1. Get admin password"
echo "2. Setup port forwarding (for UI access)"
echo "3. Login to Argo CD CLI"
echo "4. Exit"
echo ""
read -p "Choose an option (1-4): " OPTION

case $OPTION in
  1)
    get_admin_password
    ;;
  2)
    setup_port_forwarding
    ;;
  3)
    cli_login
    ;;
  4)
    exit 0
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac 