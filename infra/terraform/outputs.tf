output "runtime_public_ip" {
  description = "Fixed Public IP for the runtime node (Elastic IP)"
  value       = aws_eip.runtime_eip.public_ip
}

output "runtime_public_dns" {
  description = "Public DNS of the runtime node"
  value       = aws_eip.runtime_eip.public_dns
}

output "ssh_connection" {
  description = "SSH command to connect to the instance"
  value       = "ssh ${var.ssh_user}@${aws_eip.runtime_eip.public_ip}"
}