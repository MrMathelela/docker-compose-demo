#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
MANIFESTS=(
  "$SCRIPT_DIR/../ingress.yaml"
  "$SCRIPT_DIR/../service.yaml"
  "$SCRIPT_DIR/../deployment.yaml"
  "$SCRIPT_DIR/../secret.yaml"
  "$SCRIPT_DIR/../namespace.yaml"
)

delete_manifest() {
  local manifest=$1
  if [[ -f "$manifest" ]]; then
    echo "Deleting manifest: $manifest"
    kubectl delete -f "$manifest"
  else
    echo "Manifest $manifest not found, skipping."
  fi
}

for manifest in "${MANIFESTS[@]}"; do
  delete_manifest "$manifest"
done
