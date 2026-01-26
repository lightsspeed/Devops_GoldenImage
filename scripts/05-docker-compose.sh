#!/bin/bash
set -euo pipefail

echo "→ Installing Docker Compose v2..."
DOCKER_COMPOSE_VERSION="v2.24.5"
sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "→ Verifying Docker Compose installation..."
docker-compose --version || docker compose version
