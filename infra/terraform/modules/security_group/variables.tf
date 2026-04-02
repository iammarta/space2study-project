variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "admin_ingress_cidr" {
  description = "CIDR block allowed for admin access"
  type        = string
}