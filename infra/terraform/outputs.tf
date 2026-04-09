output "runtime_public_ip" {
  description = "Persistent public IP attached to the runtime node"
  value       = data.aws_eip.runtime_eip.public_ip
}

output "ssh_connection" {
  description = "SSH command to connect to the instance"
  value       = "ssh ${var.ssh_user}@${data.aws_eip.runtime_eip.public_ip}"
}

output "backend_ecr_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr.backend_repository_url
}

output "frontend_ecr_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr.frontend_repository_url
}