module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.private_subnet_id
  security_group = module.vpc.security_group_id
  key_name = "terra_keypair"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_cidr
  security_group_id = module.vpc.alb_sg_id
}

module "rds" {
  source = "./modules/rds"
  security_group_id = module.vpc.rds_sg_id
  db_allocated_storage = var.db_allocated_storage
  db_instance_class = var.db_instance_class
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  asg_name = module.ec2.asg_name
}

module "iam" {
  source = "./modules/iam"
}