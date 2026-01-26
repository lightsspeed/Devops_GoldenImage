#!/bin/bash
set -euo pipefail

echo "→ Installing Docker..."
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /tmp/docker.gpg
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg /tmp/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
fi

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Verify
sudo docker --version
