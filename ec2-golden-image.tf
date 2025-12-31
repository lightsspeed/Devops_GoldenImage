# SSH Key Pair
resource "aws_key_pair" "main" {
  key_name   = "${local.name_prefix}-key"
  public_key = file(var.public_key_path)

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-keypair"
    }
  )
}

# DevOps Golden Image EC2 Instance
resource "aws_instance" "golden_image" {
  ami                    = local.base_ami_id
  instance_type          = var.golden_image_instance_type
  key_name               = aws_key_pair.main.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.golden_image.id]

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.golden_image_volume_size
    iops                  = 3000
    throughput            = 125
    encrypted             = true
    delete_on_termination = true

    tags = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-root-volume"
      }
    )
  }

  user_data = file("${path.module}/user-data/golden-image-setup.sh")

  monitoring = var.enable_monitoring

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name      = "${local.name_prefix}-golden-image"
      Purpose   = "DevOps All-in-One"
      BaseImage = "Ubuntu-22.04"
    }
  )

  depends_on = [aws_internet_gateway.main]

  lifecycle {
    ignore_changes = [ami]
  }
}

# Elastic IP for Golden Image (Optional but recommended)
resource "aws_eip" "golden_image" {
  instance = aws_instance.golden_image.id
  domain   = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-eip"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# Create AMI from Golden Image (Optional)
resource "aws_ami_from_instance" "golden_ami" {
  count = var.create_ami ? 1 : 0

  name                    = "${local.name_prefix}-ami-${local.timestamp}"
  source_instance_id      = aws_instance.golden_image.id
  snapshot_without_reboot = false

  tags = merge(
    local.common_tags,
    {
      Name        = "${local.name_prefix}-ami"
      CreatedFrom = aws_instance.golden_image.id
      CreatedAt   = local.timestamp
    }
  )
}