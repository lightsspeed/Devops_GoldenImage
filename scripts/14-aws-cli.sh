#!/bin/bash
set -euo pipefail

echo "→ Installing AWS CLI..."
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "→ Verifying AWS CLI installation..."
aws --version
