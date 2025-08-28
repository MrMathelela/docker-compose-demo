#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# =====================
# Configurable Variables
# =====================
NAMESPACE="ingress-nginx"
LOCAL_NAMESPACE="local"
CERTS_DIR="$SCRIPT_DIR/../certs"
TLS_CRT="$CERTS_DIR/tls.crt"
TLS_KEY="$CERTS_DIR/tls.key"
SECRET_YAML="$SCRIPT_DIR/../secret.yaml"
MANIFESTS=(
  "$SCRIPT_DIR/../namespace.yaml"
  "$SCRIPT_DIR/../deployment.yaml"
  "$SCRIPT_DIR/../service.yaml"
  "$SCRIPT_DIR/../secret.yaml"
  "$SCRIPT_DIR/../ingress.yaml"
)

# =====================
# Utility Functions
# =====================
apply_manifest() {
  local manifest=$1
  if [[ -f "$manifest" ]]; then
    kubectl apply -f "$manifest"
  else
    echo "Warning: Manifest $manifest not found, skipping."
  fi
}

create_tls_certs() {
  mkdir -p "$CERTS_DIR"
  if [[ -f "$TLS_CRT" && -f "$TLS_KEY" ]]; then
    echo "TLS certificate and key already exist. Skipping generation."
  else
    echo "Generating TLS certificate and key..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout "$TLS_KEY" -out "$TLS_CRT" \
      -subj "/CN=mukuru.go.local/O=Local"
  fi
}

create_secret_yaml() {
  if [[ -f "$SECRET_YAML" ]]; then
    echo "secret.yaml already exists. Skipping secret creation."
  else
    echo "Creating Kubernetes TLS secret manifest..."
    kubectl -n "$LOCAL_NAMESPACE" create secret tls mukuru-http-tls \
      --cert="$TLS_CRT" --key="$TLS_KEY" \
      --dry-run=client -o yaml > "$SECRET_YAML"
  fi
}

install_ingress_nginx() {
  kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx 2>/dev/null || true
  helm repo update
  if helm status ingress-nginx -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "ingress-nginx is already installed in namespace $NAMESPACE. Skipping installation."
  else
    echo "Installing ingress-nginx..."
    helm install ingress-nginx ingress-nginx/ingress-nginx \
      --namespace "$NAMESPACE" \
      --set controller.ingressClassResource.name=nginx \
      --set controller.ingressClass=nginx \
      --set controller.watchIngressWithoutClass=true
  fi
}

# =====================
# Main Script
# =====================
set -e

install_ingress_nginx
create_tls_certs
create_secret_yaml

for manifest in "${MANIFESTS[@]}"; do
  apply_manifest "$manifest"
done
