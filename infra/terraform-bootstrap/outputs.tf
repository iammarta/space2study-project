output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "state_file_key" {
  value = var.state_file_key
}