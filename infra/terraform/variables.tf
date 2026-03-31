variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-central-1"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "app-monitor-node"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.medium"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "admin_ingress_cidr" {
  description = "CIDR block allowed for admin access"
  type        = string
}

variable "ssh_user" {
  description = "Default SSH user for Ubuntu AMI"
  type        = string
  default     = "ubuntu"
}