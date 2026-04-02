output "elastic_ip" {
  value = aws_eip.runtime_eip.public_ip
}

output "public_dns" {
  value = aws_eip.runtime_eip.public_dns
}