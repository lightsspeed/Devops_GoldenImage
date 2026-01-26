#!/bin/bash
set -euo pipefail

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
