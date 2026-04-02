variable "aws_region" {
  description = "AWS region for Terraform state resources"
  type        = string
  default     = "eu-central-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state"
  type        = string
}

variable "state_file_key" {
  description = "Path to the state file inside the bucket"
  type        = string
  default     = "space2study/dev/terraform.tfstate"
}