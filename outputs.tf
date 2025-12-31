# Instance Information
output "instance_id" {
  description = "ID of the golden image instance"
  value       = aws_instance.golden_image.id
}

output "instance_public_ip" {
  description = "Public IP address (if no EIP)"
  value       = aws_instance.golden_image.public_ip
}

output "instance_private_ip" {
  description = "Private IP address"
  value       = aws_instance.golden_image.private_ip
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.golden_image.public_ip
}

# Network Information
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.golden_image.id
}

# AMI Information
output "created_ami_id" {
  description = "ID of created AMI (if create_ami = true)"
  value       = var.create_ami ? aws_ami_from_instance.golden_ami[0].id : "AMI creation disabled"
}

output "created_ami_name" {
  description = "Name of created AMI"
  value       = var.create_ami ? aws_ami_from_instance.golden_ami[0].name : "AMI creation disabled"
}

# Connection Information
output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_eip.golden_image.public_ip}"
}

# Service URLs
output "service_urls" {
  description = "URLs for accessing services"
  value = {
    grafana    = "http://${aws_eip.golden_image.public_ip}:3000"
    prometheus = "http://${aws_eip.golden_image.public_ip}:9090"
    argocd     = "http://${aws_eip.golden_image.public_ip}:8080"
    dashboard  = "Access via: minikube dashboard --url"
  }
}

# Complete Setup Guide
output "next_steps" {
  description = "Next steps after deployment"
  value       = <<-EOT
  
  ╔════════════════════════════════════════════════════════════════════╗
  ║            DEVOPS GOLDEN IMAGE DEPLOYED SUCCESSFULLY!              ║
  ╚════════════════════════════════════════════════════════════════════╝
  
  🖥️  Instance Details:
     Instance ID:   ${aws_instance.golden_image.id}
     Public IP:     ${aws_eip.golden_image.public_ip}
     Private IP:    ${aws_instance.golden_image.private_ip}
     Instance Type: ${var.golden_image_instance_type}
     Storage:       ${var.golden_image_volume_size}GB
  
  🔐 Connect to Your Golden Image:
     ssh -i ${var.private_key_path} ubuntu@${aws_eip.golden_image.public_ip}
  
  ⏱️  Initial Setup Time:
     User-data script is running in the background (5-10 minutes)
     Check progress: tail -f /var/log/cloud-init-output.log
     Completion marker: /home/ubuntu/golden-image-ready.txt
  
  📦 Pre-installed Tools:
     ✓ Docker & Docker Compose
     ✓ Minikube (Kubernetes)
     ✓ kubectl
     ✓ Helm
     ✓ ArgoCD CLI
     ✓ Kustomize
     ✓ Terraform
     ✓ Ansible
     ✓ AWS CLI
     ✓ Prometheus
     ✓ Grafana
     ✓ Git, Vim, htop, etc.
  
  🌐 Access Services:
     Grafana:    http://${aws_eip.golden_image.public_ip}:3000 (admin/admin)
     Prometheus: http://${aws_eip.golden_image.public_ip}:9090
     ArgoCD:     http://${aws_eip.golden_image.public_ip}:8080
  
  📖 Useful Commands (run on the instance):
     # Check setup status
     cat ~/golden-image-ready.txt
     
     # Minikube
     minikube status
     minikube dashboard --url
     
     # Kubernetes
     kubectl get nodes
     kubectl get pods -A
     
     # Helm
     helm list -A
     
     # ArgoCD
     argocd version
     cat ~/argocd-password.txt
  
  💾 Create AMI from this instance:
     1. Ensure all configurations are complete
     2. Run: terraform apply -var="create_ami=true"
     3. AMI will be created with name: ${local.name_prefix}-ami-${local.timestamp}
  
  📚 Documentation:
     - Full setup details: ~/setup-log.txt
     - ArgoCD credentials: ~/argocd-password.txt
     - Service ports: ~/service-ports.txt
  
  EOT
}

# Quick Reference
output "quick_reference" {
  description = "Quick reference guide"
  value = {
    elastic_ip        = aws_eip.golden_image.public_ip
    ssh_command       = "ssh -i ${var.private_key_path} ubuntu@${aws_eip.golden_image.public_ip}"
    grafana_url       = "http://${aws_eip.golden_image.public_ip}:3000"
    prometheus_url    = "http://${aws_eip.golden_image.public_ip}:9090"
    argocd_url        = "http://${aws_eip.golden_image.public_ip}:8080"
    instance_id       = aws_instance.golden_image.id
    security_group_id = aws_security_group.golden_image.id
  }
}