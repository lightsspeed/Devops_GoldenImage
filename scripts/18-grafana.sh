#!/bin/bash
set -euo pipefail

# Install Grafana using Helm
echo "→ Preparing Grafana installation via Helm..."

# First, clean up any broken package installations
sudo apt-get remove --purge -y grafana 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt --fix-broken install -y

# Add Grafana Helm repository as ubuntu user
sudo -u ubuntu helm repo add grafana https://grafana.github.io/helm-charts 2>/dev/null || true
sudo -u ubuntu helm repo update

echo "→ Grafana Helm chart added. Run: helm install grafana grafana/grafana"
