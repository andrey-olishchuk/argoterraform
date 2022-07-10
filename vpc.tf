data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name                 = "terraform-vpc"
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "kubernetes.io/cluster/terraform" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/terraform" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/terraform" = "shared"
  }
}