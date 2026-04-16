provider "aws" {}

resource "aws_vpc" "development_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}



module "myapp-subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.development_vpc.id
  subnet_cidr = var.subnet_cidr
  availability_zone = var.availability_zone
  env_prefix = var.env_prefix
  default_route_table_id = aws_vpc.development_vpc.default_route_table_id
}


module "myapp-server" {
  source = "./modules/webserver"
  availability_zone = var.availability_zone
  env_prefix = var.env_prefix
  instance_type = var.instance_type
  my_ip = var.my_ip
  public_key_location = var.public_key_location
  vpc_id = aws_vpc.development_vpc.id
  image_name = var.image_name
  subnet_id  = module.myapp-subnet.subnet.id
}