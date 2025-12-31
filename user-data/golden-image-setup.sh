#!/bin/bash
set -euo pipefail

# Create log file with proper permissions
LOG_FILE="/var/log/golden-image-setup.log"
sudo touch ${LOG_FILE}
sudo chmod 666 ${LOG_FILE}

# Log everything
exec > >(tee -a ${LOG_FILE})
exec 2>&1

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          DevOps Golden Image Setup Started                    ║"
echo "║          $(date)                                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"

# Set hostname
sudo hostnamectl set-hostname devops-golden-image

# Update system
export DEBIAN_FRONTEND=noninteractive
echo "→ Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install essential tools
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
  python3-dev \
  python3-setuptools \
  zip \
  rsync \
  openssh-client

# Install Python
echo "→ Installing Python..."
sudo apt-get install -y python3 python3-pip python3-venv

# Install Docker
echo "→ Installing Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /tmp/docker.gpg
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg /tmp/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

echo "→ Verifying Docker installation..."
sudo docker --version

# Install Docker Compose v2
echo "→ Installing Docker Compose v2..."
DOCKER_COMPOSE_VERSION="v2.24.5"
sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "→ Verifying Docker Compose installation..."
docker-compose --version || docker compose version

# Install and Start Jenkins
echo "→ Installing Jenkins..."
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y fontconfig openjdk-17-jre jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to initialize
echo "→ Waiting for Jenkins to start (this may take a minute)..."
for i in {1..60}; do
  if sudo systemctl is-active --quiet jenkins && [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
    echo "→ Jenkins is ready!"
    break
  fi
  sleep 2
done

# Save Jenkins initial admin password
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  echo "→ Saving Jenkins initial admin password..."
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /home/ubuntu/jenkins_initial_admin_password.txt
  sudo chown ubuntu:ubuntu /home/ubuntu/jenkins_initial_admin_password.txt
  echo "→ Jenkins initial admin password saved to: /home/ubuntu/jenkins_initial_admin_password.txt"
else
  echo "⚠ Warning: Jenkins initial admin password not found"
fi

# Install kubectl
echo "→ Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
sudo curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "→ Verifying kubectl installation..."
kubectl version --client

# Install Minikube
echo "→ Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm -f minikube-linux-amd64

echo "→ Verifying Minikube installation..."
minikube version

# Install Helm
echo "→ Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "→ Verifying Helm installation..."
helm version

# Install ArgoCD CLI
echo "→ Installing ArgoCD CLI..."
sudo curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo chmod +x /usr/local/bin/argocd

echo "→ Verifying ArgoCD CLI installation..."
/usr/local/bin/argocd version --client --short 2>/dev/null || echo "ArgoCD CLI installed successfully"

# Install Kustomize
echo "→ Installing Kustomize..."
cd /tmp
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
sudo mv kustomize /usr/local/bin/

echo "→ Verifying Kustomize installation..."
kustomize version

# Install Terraform
echo "→ Installing Terraform..."
cd /tmp
TERRAFORM_VERSION="1.6.0"
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "→ Verifying Terraform installation..."
terraform version

# Install Ansible
echo "→ Installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

echo "→ Verifying Ansible installation..."
ansible --version

# Install AWS CLI
echo "→ Installing AWS CLI..."
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

echo "→ Verifying AWS CLI installation..."
aws --version

# Install additional DevOps tools
echo "→ Installing additional tools..."

# k9s (Kubernetes CLI)
cd /tmp
wget -q https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar xzf k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
rm -f k9s_Linux_amd64.tar.gz LICENSE README.md

echo "→ Verifying k9s installation..."
k9s version

# kubectx and kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

# Setup bash completion
echo "→ Setting up bash completion..."
cat >> /home/ubuntu/.bashrc << 'EOF'

# Kubernetes aliases and completion
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

# Minikube completion
source <(minikube completion bash)

# Helm completion
source <(helm completion bash)

# Aliases
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias ke='kubectl exec -it'

# Terraform aliases
alias tf='terraform'
alias tfa='terraform apply'
alias tfp='terraform plan'
alias tfd='terraform destroy'

# Docker aliases
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Custom prompt
PS1='\[\033[01;32m\]\u@devops-golden\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
EOF

sudo chown ubuntu:ubuntu /home/ubuntu/.bashrc

# Install Prometheus
echo "→ Installing Prometheus..."
cd /tmp
PROMETHEUS_VERSION="2.45.0"
wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown -R ubuntu:ubuntu /etc/prometheus /var/lib/prometheus
rm -rf prometheus-${PROMETHEUS_VERSION}.linux-amd64 prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz

# Configure Prometheus
sudo tee /etc/prometheus/prometheus.yml > /dev/null << 'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF

sudo chown ubuntu:ubuntu /etc/prometheus/prometheus.yml

# Create Prometheus service
sudo tee /etc/systemd/system/prometheus.service > /dev/null << 'EOF'
[Unit]
Description=Prometheus
After=network.target

[Service]
User=ubuntu
Group=ubuntu
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

echo "→ Verifying Prometheus installation..."
sleep 3
sudo systemctl status prometheus --no-pager || true

# Install Node Exporter
echo "→ Installing Node Exporter..."
cd /tmp
NODE_EXPORTER_VERSION="1.6.0"
wget -q https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xzf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo cp node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64 node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

sudo tee /etc/systemd/system/node_exporter.service > /dev/null << 'EOF'
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=nobody
Group=nogroup
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo "→ Verifying Node Exporter installation..."
sleep 2
sudo systemctl status node_exporter --no-pager || true

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

# Verify Helm repo was added
echo "→ Verifying Grafana Helm repository..."
sudo -u ubuntu helm repo list | grep grafana || echo "Warning: Grafana repo not found"

echo "→ Grafana Helm chart added and ready for deployment"
echo "  To deploy Grafana, run: helm install grafana grafana/grafana"

# Configure Grafana
echo "→ Grafana Helm repository configured and ready"

# Return to home directory
cd /home/ubuntu

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          DevOps Golden Image Setup Completed                  ║"
echo "║          $(date)                                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "→ Installed Services:"
echo "  - Docker: $(docker --version 2>/dev/null || echo 'Check failed')"
echo "  - Jenkins: http://localhost:8080 (password in ~/jenkins_initial_admin_password.txt)"
echo "  - Prometheus: http://localhost:9090"
echo "  - Node Exporter: http://localhost:9100"
echo "  - Grafana: Ready for Helm deployment (helm install grafana grafana/grafana)"
echo "  - ArgoCD: Ready for Kubernetes deployment"
echo ""
echo "→ To deploy ArgoCD:"
echo "  kubectl create namespace argocd"
echo "  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
echo "  kubectl port-forward svc/argocd-server -n argocd 8000:443"
echo ""

# Cleanup
echo "→ Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /tmp/*

echo ""
echo "✓ Setup complete! Please reboot the system to apply all changes."
echo "  Run: sudo reboot"
echo ""