#!/bin/bash
set -euo pipefail

echo "→ Installing Terraform..."

TERRAFORM_VERSION="1.14.3"

cd /tmp

curl -fsSLo terraform.zip \
  https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

unzip -o terraform.zip
sudo mv terraform /usr/local/bin/terraform
rm -f terraform.zip

echo "→ Verifying Terraform installation..."
terraform version
