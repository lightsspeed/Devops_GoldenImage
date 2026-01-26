#!/bin/bash
set -euo pipefail

echo "→ Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

echo "→ Verifying Minikube installation..."
minikube version
