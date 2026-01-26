#!/bin/bash
set -euo pipefail

echo "→ Installing Kustomize..."
cd /tmp
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/

echo "→ Verifying Kustomize installation..."
kustomize version
