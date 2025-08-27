#!/bin/bash

# Add ingress-nginx repo if not already present
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true

# Check if ingress-nginx is already installed
if helm status ingress-nginx >/dev/null 2>&1; then
  echo "ingress-nginx is already installed. Skipping installation."
else
  echo "Installing ingress-nginx..."
  helm install ingress-nginx ingress-nginx/ingress-nginx
fi

# Create certs directory if not exists
mkdir -p "./certs"

# Check if TLS certificate and key already exist
if [[ -f ./certs/tls.crt && -f ./certs/tls.key ]]; then
  echo "TLS certificate and key already exist. Skipping generation."
else
  echo "Generating TLS certificate and key..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ./certs/tls.key -out ./certs/tls.crt \
    -subj "/CN=mukuru.go.local/O=Local"
fi

# Check if secret.yaml already exists
if [[ -f ./secret.yaml ]]; then
  echo "secret.yaml already exists. Skipping secret creation."
else
  echo "Creating Kubernetes TLS secret manifest..."
  kubectl -n local create secret tls mukuru-http-tls \
    --cert=./certs/tls.crt --key=./certs/tls.key \
    --dry-run=client -o yaml > ./secret.yaml
fi

# Apply the Kubernetes manifests
kubectl apply -f "../k8s/namespace.yaml"
kubectl apply -f "../k8s//deployment.yaml"
kubectl apply -f "../k8s//service.yaml"
kubectl apply -f "../k8s//secret.yaml"
kubectl apply -f "../k8s//ingress.yaml"
