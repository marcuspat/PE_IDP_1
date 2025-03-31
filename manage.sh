#!/bin/bash
set -e

PROJECT_ID="your-project-id"
CLUSTER_NAME="pe-idp-1-cluster"
REGION="us-central1-a"

usage() {
  echo "Usage: $0 {up|down}"
  exit 1
}

setup_kubectl() {
  gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID
}

deploy() {
  echo "Deploying PE_IDP_1 components..."

  # Namespaces
  kubectl apply -f - <<EOF
  apiVersion: v1
  kind: Namespace
  metadata:
    name: argocd
  ---
  apiVersion: v1
  kind: Namespace
  metadata:
    name: monitoring
  ---
  apiVersion: v1
  kind: Namespace
  metadata:
    name: backstage
  EOF

  # ArgoCD
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

  # Prometheus/Grafana
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring

  # App Manifests with Secrets Manager Integration
  kubectl apply -f manifests/

  # ArgoCD Application
  kubectl apply -f argocd/app.yaml

  # Backstage
  kubectl apply -f backstage/backstage.yaml

  echo "Waiting for deployments..."
  sleep 30
  kubectl get all -A
}

teardown() {
  echo "Tearing down PE_IDP_1 components..."
  kubectl delete -f argocd/app.yaml || true
  kubectl delete -f manifests/ || true
  kubectl delete -f backstage/backstage.yaml || true
  helm uninstall prometheus -n monitoring || true
  kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || true
  kubectl delete ns argocd monitoring backstage || true
  echo "Cleanup complete."
}

if [ $# -ne 1 ]; then
  usage
fi

case $1 in
  "up")
    setup_kubectl
    deploy
    ;;
  "down")
    setup_kubectl
    teardown
    ;;
  *)
    usage
    ;;
esac