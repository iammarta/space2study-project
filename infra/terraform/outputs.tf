output "runtime_public_ip" {
  description = "Public IP of runtime EC2 instance"
  value       = aws_instance.runtime.public_ip
}

output "runtime_public_dns" {
  description = "Public DNS of runtime EC2 instance"
  value       = aws_instance.runtime.public_dns
}

output "ssh_connection" {
  description = "SSH command"
  value       = "ssh ${var.ssh_user}@${aws_instance.runtime.public_ip}"
}