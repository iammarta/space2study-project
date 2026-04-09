module "key_pair" {
  source          = "./modules/key_pair"
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  public_subnet_cidr = var.public_subnet_cidr
}

module "security_group" {
  source             = "./modules/security_group"
  vpc_id             = module.vpc.vpc_id
  admin_ingress_cidr = var.admin_ingress_cidr
}

module "ec2" {
  source                 = "./modules/ec2"
  instance_name          = var.instance_name
  instance_type          = var.instance_type
  root_volume_size       = var.root_volume_size
  subnet_id              = module.subnet.subnet_id
  vpc_security_group_ids = [module.security_group.security_group_id]
  key_name               = module.key_pair.key_name
}

data "aws_eip" "runtime_eip" {
  id = var.eip_allocation_id
}

resource "aws_eip_association" "runtime_eip_assoc" {
  instance_id   = module.ec2.instance_id
  allocation_id = var.eip_allocation_id
}

module "ecr" {
  source = "./modules/ecr"

  backend_repo_name  = var.backend_repo_name
  frontend_repo_name = var.frontend_repo_name
}