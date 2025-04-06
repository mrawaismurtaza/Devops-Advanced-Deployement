#!/bin/bash

# This script demonstrates how to rollback a failed deployment using Argo CD

# Check if application name is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <application-name>"
  echo "Example: $0 devops-advanced-deployment"
  exit 1
fi

APPLICATION_NAME=$1

# Function to get the latest revision history
get_revision_history() {
  echo "Fetching revision history for $APPLICATION_NAME..."
  argocd app history $APPLICATION_NAME -o wide
}

# Function to rollback to a specific revision
rollback_to_revision() {
  if [ $# -ne 1 ]; then
    echo "No revision specified. Please provide a revision number."
    exit 1
  fi
  
  REVISION=$1
  echo "Rolling back $APPLICATION_NAME to revision $REVISION..."
  argocd app rollback $APPLICATION_NAME $REVISION --prune
}

# Function to simulate a failed deployment
simulate_failed_deployment() {
  echo "Simulating a failed deployment by applying a broken image tag..."
  
  # Get the current kubectl manifest file for the backend deployment
  TEMP_FILE=$(mktemp)
  kubectl get deployment backend -n prod -o yaml > $TEMP_FILE
  
  # Replace the image tag with a non-existent one
  sed -i 's/\(image: .*\):.*/\1:broken-tag/' $TEMP_FILE
  
  # Apply the broken deployment
  echo "Applying broken deployment..."
  kubectl apply -f $TEMP_FILE
  
  # Clean up temp file
  rm $TEMP_FILE
  
  echo "Failed deployment simulated. Argo CD should detect the drift and try to reconcile."
  echo "If automatic sync is enabled, Argo CD will try to fix it."
  echo "Otherwise, you'll need to manually sync or rollback."
}

# Main menu
echo "========================================"
echo "Argo CD Rollback Utility"
echo "========================================"
echo "Application: $APPLICATION_NAME"
echo ""
echo "1. Show revision history"
echo "2. Rollback to specific revision"
echo "3. Simulate failed deployment"
echo "4. Exit"
echo ""
read -p "Choose an option (1-4): " OPTION

case $OPTION in
  1)
    get_revision_history
    ;;
  2)
    get_revision_history
    echo ""
    read -p "Enter revision number to rollback to: " REVISION
    rollback_to_revision $REVISION
    ;;
  3)
    simulate_failed_deployment
    ;;
  4)
    exit 0
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac

echo "Done!" 