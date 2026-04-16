resource "aws_security_group" "runtime_sg" {
  name        = "runtime-sg"
  description = "Allow SSH, HTTP app, and Grafana NodePort"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ingress_cidr]
  }

  ingress {
    description = "HTTP app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana NodePort"
    from_port   = 32000
    to_port     = 32000
    protocol    = "tcp"
    cidr_blocks = [var.admin_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "space2study-runtime-sg"
  }
}