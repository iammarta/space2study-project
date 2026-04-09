output "elastic_ip" {
  description = "Persistent Elastic IP address"
  value       = aws_eip.runtime_eip.public_ip
}

output "allocation_id" {
  description = "Allocation ID of the persistent Elastic IP"
  value       = aws_eip.runtime_eip.id
}

output "grafana_secret_name" {
  description = "AWS Secrets Manager secret name for Grafana admin credentials"
  value       = aws_secretsmanager_secret.grafana_admin.name
}