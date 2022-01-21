provider "aws" {
  region = var.region
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidrBlock
  enable_dns_support   = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name
  enable_classiclink   = false
  instance_tenancy     = "default"
  tags = {
    Name = "main-vpc"
  }

}

data "aws_availability_zones" "this" {
  state = "available"
}

#Create subnet # 1 in us-east-1
resource "aws_subnet" "this" {
  availability_zone       = element(data.aws_availability_zones.this.names, 0)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.subnetCidrBlock
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
