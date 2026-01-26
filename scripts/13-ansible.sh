#!/bin/bash
set -euo pipefail

echo "→ Installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "→ Verifying Ansible installation..."
ansible --version
