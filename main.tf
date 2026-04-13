provider "aws" {
  region     = "eu-north-1"
}

resource "aws_vpc" "development_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "development_subnet" {
  vpc_id            = aws_vpc.development_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
}
