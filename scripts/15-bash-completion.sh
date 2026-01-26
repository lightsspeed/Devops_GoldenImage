#!/bin/bash
set -euo pipefail

USER_NAME="ubuntu"
HOME_DIR="/home/${USER_NAME}"
ALIASES_FILE="${HOME_DIR}/.bash_aliases"

echo "→ Setting up bash aliases for ${USER_NAME}..."

# Create aliases file if not exists
if [ ! -f "${ALIASES_FILE}" ]; then
  touch "${ALIASES_FILE}"
fi

cat > "${ALIASES_FILE}" << 'EOF'
########################################
# DevOps Bash Aliases
########################################

# General
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='ss -tulanp'
alias install='sudo apt install -y'
alias remove='sudo apt remove -y'
alias bashrc='nano ~/.bashrc'
alias srcbash='source ~/.bashrc'
alias c='clear'

# Git
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gp='git push'
alias gpu='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch'
alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gf='git fetch'

# Docker
alias d='docker'
alias di='docker images'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstart='docker start'
alias dstop='docker stop'
alias drestart='docker restart'
alias drm='docker rm'
alias drmi='docker rmi'
alias dlog='docker logs'
alias dexec='docker exec -it'
alias dprune='docker system prune -f'
alias dprunea='docker system prune -af'

# Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up'
alias dcupd='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcps='docker-compose ps'
alias dclogs='docker-compose logs'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgd='kubectl get deployments'
alias kgs='kubectl get services'
alias kgn='kubectl get nodes'
alias kga='kubectl get all -A'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'

# Helm
alias h='helm'
alias hl='helm list'
alias hi='helm install'
alias hu='helm upgrade'
alias hun='helm uninstall'

# Terraform
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfv='terraform validate'

# AWS
alias aws-whoami='aws sts get-caller-identity'

# Ansible
alias ap='ansible-playbook'
alias al='ansible-lint'
EOF

# Ensure ownership
chown "${USER_NAME}:${USER_NAME}" "${ALIASES_FILE}"

# Ensure .bashrc sources .bash_aliases
if ! grep -q ".bash_aliases" "${HOME_DIR}/.bashrc"; then
  echo "[ -f ~/.bash_aliases ] && source ~/.bash_aliases" >> "${HOME_DIR}/.bashrc"
fi

echo "→ Bash aliases installed successfully"
