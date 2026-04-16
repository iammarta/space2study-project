resource "aws_eip" "runtime_eip" {
  domain = "vpc"

  tags = {
    Name = "runtime-static-ip"
  }
}

resource "aws_secretsmanager_secret" "grafana_admin" {
  name        = "space2study/grafana-admin"
  description = "Grafana admin credentials for Space2Study"

  tags = {
    Name = "space2study-grafana-admin"
  }
}

resource "aws_secretsmanager_secret_version" "grafana_admin" {
  secret_id = aws_secretsmanager_secret.grafana_admin.id

  secret_string = jsonencode({
    username = var.grafana_admin_user
    password = var.grafana_admin_password
  })
}