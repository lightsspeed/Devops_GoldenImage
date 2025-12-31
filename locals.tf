locals {
  # Common tags
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
      ImageType   = "GoldenImage"
    },
    var.additional_tags
  )

  # Resource naming
  name_prefix = "${var.project_name}-${var.environment}"

  # Availability zone
  availability_zone = data.aws_availability_zones.available.names[0]

  # AMI ID
  base_ami_id = data.aws_ami.ubuntu.id

  # Account and region info
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # Timestamp for AMI naming
  timestamp = formatdate("YYYY-MM-DD-hhmm", timestamp())
}