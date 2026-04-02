resource "aws_eip" "runtime_eip" {
  instance = var.instance_id
  domain   = "vpc"

  tags = {
    Name = "runtime-static-ip"
  }
}