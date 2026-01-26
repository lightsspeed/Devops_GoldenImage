#!/bin/bash
set -euo pipefail

echo "→ Updating system packages..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y
