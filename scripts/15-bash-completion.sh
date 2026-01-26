#!/bin/bash
set -euo pipefail

echo "→ Setting up bash completion..."
cat >> /home/ubuntu/.bashrc << 'EOF'

# General Linux aliases
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias free='free -m'
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='netstat -tulanp'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias tarc='tar -czvf'  # Create tar.gz archive
alias tarx='tar -xzvf'  # Extract tar.gz archive
alias bashrc='nano ~/.bashrc'
alias srcbash='source ~/.bashrc'
alias sud='su -'

# Git aliases
alias gi='git init'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -m'
alias gp='git push'
alias gpu='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gb='git branch' #list branch
alias gba='git branch -a'  # List all branches (local and remote)
alias gbd='git branch -d'  # Delete a branch
alias gbD='git branch -D'  # Force delete a branch
alias gco='git checkout'  # Switch branches or restore working tree files
alias gcob='git checkout -b'  # Create and switch to a new branch
alias gcom='git checkout master'  # Switch to master branch
alias gcod='git checkout develop'  # Switch to develop branch
alias gf='git fetch'  # Download objects and refs from another repository
alias gl='git log'  # Show commit logs

# Docker aliases
# Basic Docker commands
alias d='docker'  # Shorthand for docker
alias di='docker images'  # List Docker images
alias dps='docker ps'  # List running containers
alias dpsa='docker ps -a'  # List all containers (including stopped ones)
alias drm='docker rm'  # Remove one or more containers
alias drmi='docker rmi'  # Remove one or more images
alias dpr='docker prune'  # Remove unused data

# Container lifecycle
alias dstart='docker start'  # Start one or more stopped containers
alias dstop='docker stop'  # Stop one or more running containers
alias drestart='docker restart'  # Restart one or more containers
alias dpause='docker pause'  # Pause all processes within one or more containers
alias dunpause='docker unpause'  # Unpause all processes within one or more containers

# Container interaction
alias dexec='docker exec -it'  # Run a command in a running container
alias dlog='docker logs'  # Fetch the logs of a container
alias dlogt='docker logs --tail 100 -f'  # Fetch the last 100 lines of logs and follow output
alias dtop='docker top'  # Display the running processes of a container
alias dstats='docker stats'  # Display a live stream of container(s) resource usage statistics

# Image management
alias dpull='docker pull'  # Pull an image or a repository from a registry
alias dpush='docker push'  # Push an image or a repository to a registry
alias dbuild='docker build'  # Build an image from a Dockerfile
alias dtag='docker tag'  # Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

# Volume management
alias dvls='docker volume ls'  # List volumes
#alias dvcreate= 'docker volume create'  # Create a volume
alias dvrm='docker volume rm'  # Remove one or more volumes

# Network management
alias dnls='docker network ls'  # List networks
#alias dncreate= 'docker network create'  # Create a network
alias dnrm='docker network rm'  # Remove one or more networks

# System-wide commands
alias dinfo='docker info'  # Display system-wide information
alias dversion='docker version'  # Show the Docker version information
alias devents='docker events'  # Get real time events from the server

# Cleanup commands
alias dprune='docker system prune'  # Remove unused data
alias dprunea='docker system prune -a'  # Remove all unused data including unused images
alias drmid='docker rmi $(docker images -f "dangling=true" -q)'  # Remove dangling images

# Docker Compose
alias dc='docker-compose'  # Shorthand for docker-compose
alias dcup='docker-compose up'  # Create and start containers
alias dcupd='docker-compose up -d'  # Create and start containers in detached mode
alias dcdown='docker-compose down'  # Stop and remove containers, networks, images, and volumes
alias dcstart='docker-compose start'  # Start services
alias dcstop='docker-compose stop'  # Stop services
alias dcrestart='docker-compose restart'  # Restart services
alias dcps='docker-compose ps'  # List containers
alias dcexec='docker-compose exec'  # Execute a command in a running container
alias dclogs='docker-compose logs'  # View output from containers

# Advanced aliases
alias dcc='docker rm $(docker ps -aq)'  # Remove all containers
alias dci='docker rmi $(docker images -q)'  # Remove all images
alias dcv='docker volume rm $(docker volume ls -q)'  # Remove all volumes

# Inspection and Debugging
alias dinspect='docker inspect'  # Return low-level information on Docker objects
alias dport='docker port'  # List port mappings or a specific mapping for the container

# Image building
alias dbuildx='docker buildx'  # Extended build capabilities with BuildKit

# Docker Hub
alias dsearch='docker search'  # Search the Docker Hub for images

# Health check
alias dhealth='docker inspect --format="{{json .State.Health}}"'  # Check the health status of a container

# Kubernetes aliases
# Basic Kubernetes commands
alias k='kubectl'  # Shorthand for kubectl
alias kgp='kubectl get pods'  # List all pods in the current namespace
alias kgpa='kubectl get pods --all-namespaces'  # List all pods in all namespaces
alias kgd='kubectl get deployments'  # List all deployments in the current namespace
alias kgs='kubectl get services'  # List all services in the current namespace
alias kgn='kubectl get nodes'  # List all nodes in the cluster
alias kga='kubectl get all -A'
# Namespace management
alias kgns='kubectl get namespaces'  # List all namespaces
alias kcn='kubectl create namespace'  # Create a new namespace
alias kdn='kubectl delete namespace'  # Delete a namespace
alias kgall='kubectl get all --all-namespaces'  # Get all resources in all namespaces

# Pod management
alias kdp='kubectl describe pod'  # Describe a pod
alias kdelp='kubectl delete pod'  # Delete a pod
alias kgpl='kubectl get pods -l'  # Get pods by label selector

# Deployment management
alias kdd='kubectl describe deployment'  # Describe a deployment
alias kdeld='kubectl delete deployment'  # Delete a deployment
alias ksd='kubectl scale deployment'  # Scale a deployment

# Service management
alias kds='kubectl describe service'  # Describe a service
alias kdels='kubectl delete service'  # Delete a service

# Log commands
alias kl='kubectl logs'  # Get logs for a container in a pod
alias klf='kubectl logs -f'  # Stream logs from a container in a pod

# Exec commands
alias kex='kubectl exec -it'  # Execute a command in a container

# Config and context
alias kgc='kubectl config get-contexts'  # List all contexts
alias ksc='kubectl config set-context'  # Set the current context
alias kcc='kubectl config current-context'  # Show the current context
alias kuc='kubectl config use-context'  # Switch to a different context

# Resource management
alias kaf='kubectl apply -f'  # Apply a configuration to a resource by filename
alias kdf='kubectl delete -f'  # Delete a resource by filename

# Rollout and update
alias krd='kubectl rollout deployment'  # Manage the rollout of a deployment
alias kru='kubectl rollout undo'  # Undo a previous rollout

# Node management
alias kdn='kubectl describe node'  # Describe a node
alias kcordon='kubectl cordon'  # Mark node as unschedulable
alias kuncordon='kubectl uncordon'  # Mark node as schedulable
alias kdrain='kubectl drain'  # Drain node in preparation for maintenance

# Cluster info
alias kci='kubectl cluster-info'  # Display cluster info
alias ktop='kubectl top'  # Display Resource (CPU/Memory) usage

# Namespace switching
alias kns='kubectl config set-context --current --namespace'  # Switch to a different namespace

# Watching resources
alias kwp='kubectl get pods -o wide --watch'  # Watch pods with more details
alias kwd='kubectl get deployments -o wide --watch'  # Watch deployments with more details

# Advanced commands
alias kpf='kubectl port-forward'  # Forward one or more local ports to a pod
alias kcp='kubectl cp'  # Copy files and directories to and from containers
alias krollout='kubectl rollout'  # Manage the rollout of a resource
alias kdiff='kubectl diff -f'  # Diff live version against a would-be applied version

# Custom resource definitions
alias kgcrd='kubectl get crd'  # List all custom resource definitions

# Events
alias kge='kubectl get events --sort-by=.metadata.creationTimestamp'  # Get sorted events

# Secret management
alias kgsec='kubectl get secrets'  # List all secrets
alias kcsec='kubectl create secret'  # Create a new secret

# ConfigMap management
alias kgcm='kubectl get configmaps'  # List all configmaps
alias kccm='kubectl create configmap'  # Create a new configmap

# Job and CronJob management
alias kgj='kubectl get jobs'  # List all jobs
alias kgcj='kubectl get cronjobs'  # List all cron jobs

# Debugging
alias kdebug='kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh'  # Start a debugging container

# API resources
alias kapi='kubectl api-resources'  # List all supported API resources

# Explain resources
alias kexp='kubectl explain'  # Get documentation for resource
# Helm aliases
alias h='helm'
alias hl='helm list'
alias hi='helm install'
alias hu='helm upgrade'
alias hun='helm uninstall'

# Terraform aliases
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfo='terraform output'
alias tfw='terraform workspace'
alias tfv='terraform validate'


# AWS CLI aliases
alias aws-whoami='aws sts get-caller-identity'
alias aws-ls='aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId,State.Name,PrivateIpAddress,PublicIpAddress,InstanceType,KeyName,Tags[?Key==`Name`].Value|[0]]" --output table'

# Ansible aliases
alias ap='ansible-playbook'
alias al='ansible-lint'

# Add your custom aliases and functions here
alias c='clear'
EOF

sudo chown ubuntu:ubuntu /home/ubuntu/.bashrc
