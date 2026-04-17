# variable env_prefix {}

provider "aws" {
    region = "eu-north-1"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_block {}
variable public_subnet_cidr_block {}
variable azs {}

data "aws_availability_zones" "azs" {
  state = "available"
}

output "available_zones" {
  value = data.aws_availability_zones.azs.names
}

module "myapp-vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "6.6.1"
    name = "myapp-vpc"
    cidr = var.vpc_cidr_block
    private_subnets = var.private_subnet_cidr_block
    public_subnets = var.public_subnet_cidr_block
    azs = data.aws_availability_zones.azs.names
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = "1"
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = "1"
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = "1"
    }
}

output "vpc_id" {
    value = module.myapp-vpc.vpc_id
}

output "private_subnets" {
    value = module.myapp-vpc.private_subnets

}