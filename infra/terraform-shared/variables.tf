variable "aws_region" {
  description = "AWS region for shared resources"
  type        = string
  default     = "eu-central-1"
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}