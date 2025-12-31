
# Security Group for Golden Image
resource "aws_security_group" "golden_image" {
  name_prefix = "${local.name_prefix}-golden-"
  description = "Security group for DevOps Golden Image"
  vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-golden-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# SSH Access
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.golden_image.id
  description       = "SSH access"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = var.allowed_ssh_cidr[0]

  tags = {
    Name = "ssh"
  }
}

# HTTP
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.golden_image.id
  description       = "HTTP access"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = var.allowed_web_cidr[0]

  tags = {
    Name = "http"
  }
}

# HTTPS
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.golden_image.id
  description       = "HTTPS access"

  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
  cidr_ipv4   = var.allowed_web_cidr[0]

  tags = {
    Name = "https"
  }
}

#Jenkins
resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  security_group_id = aws_security_group.golden_image.id
  description       = "Jenkins"

  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"
  cidr_ipv4   = var.allowed_web_cidr[0]
  tags = {
    Name = "jenkins"
  }
}

# Grafana
resource "aws_vpc_security_group_ingress_rule" "grafana" {
  security_group_id = aws_security_group.golden_image.id
  description       = "Grafana dashboard"

  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "grafana"
  }
}

# Prometheus
resource "aws_vpc_security_group_ingress_rule" "prometheus" {
  security_group_id = aws_security_group.golden_image.id
  description       = "Prometheus"

  from_port   = 9090
  to_port     = 9090
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "prometheus"
  }
}

# ArgoCD
resource "aws_vpc_security_group_ingress_rule" "argocd" {
  security_group_id = aws_security_group.golden_image.id
  description       = "ArgoCD"

  from_port   = 8000
  to_port     = 8000
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "argocd"
  }
}

# Kubernetes API
resource "aws_vpc_security_group_ingress_rule" "k8s_api" {
  security_group_id = aws_security_group.golden_image.id
  description       = "Kubernetes API"

  from_port   = 8443
  to_port     = 8443
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "k8s-api"
  }
}

# NodePort Services Range
resource "aws_vpc_security_group_ingress_rule" "nodeport" {
  security_group_id = aws_security_group.golden_image.id
  description       = "NodePort services"

  from_port   = 30000
  to_port     = 32767
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "nodeport"
  }
}

# Minikube Dashboard
resource "aws_vpc_security_group_ingress_rule" "minikube_dashboard" {
  security_group_id = aws_security_group.golden_image.id
  description       = "Minikube Dashboard"

  from_port   = 30001
  to_port     = 30001
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "minikube-dashboard"
  }
}

# All Egress
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.golden_image.id
  description       = "Allow all outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "all-egress"
  }
}