output "runtime_public_ip" {
  description = "Fixed Public IP for the runtime node (Elastic IP)"
  value       = module.eip.elastic_ip
}

output "runtime_public_dns" {
  description = "Public DNS of the runtime node"
  value       = module.eip.public_dns
}

output "ssh_connection" {
  description = "SSH command to connect to the instance"
  value       = "ssh ${var.ssh_user}@${module.eip.elastic_ip}"
}

output "backend_ecr_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr.backend_repository_url
}

output "frontend_ecr_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr.frontend_repository_url
}