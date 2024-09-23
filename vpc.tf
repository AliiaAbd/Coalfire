module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"
  name = "${var.name}-vpc"
  cidr = var.vpc_cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  tags = var.tags
}
output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}
