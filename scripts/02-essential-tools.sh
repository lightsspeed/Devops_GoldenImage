#!/bin/bash
set -euo pipefail

echo "→ Installing essential tools..."
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  software-properties-common \
  git \
  vim \
  wget \
  unzip \
  htop \
  net-tools \
  jq \
  tree \
  tmux \
  socat \
  conntrack \
  ipvsadm \
  build-essential \
  bash-completion \
  libssl-dev \
  libffi-dev \
  zip \
  rsync \
  openssh-client
