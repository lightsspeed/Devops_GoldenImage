#!/bin/bash
set -euo pipefail

echo "→ Installing Terraform..."
cd /tmp
TERRAFORM_VERSION="1.6.0"
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "→ Verifying Terraform installation..."
terraform version
