terraform {
  backend "s3" {
    bucket       = "space2study-tf-state"
    key          = "space2study/dev/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
  }
}