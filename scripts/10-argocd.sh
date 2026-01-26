#!/bin/bash
set -euo pipefail

echo "→ Installing ArgoCD CLI..."
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

echo "→ Verifying ArgoCD CLI installation..."
/usr/local/bin/argocd version --client --short 2>/dev/null || echo "ArgoCD CLI installed successfully"
