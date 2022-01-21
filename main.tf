variable "main_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.main_region
}

module "vpc" {
  source = "./modules/vpc"
  cidrBlock = "172.16.0.0/16"
  subnetCidrBlock = "172.16.1.0/24"
  region = var.main_region
}
module "sg" {
  source = "./modules/sg"
  vpcid = module.vpc.myvpc
  region = var.main_region
}
resource "aws_instance" "my-instance" {
  ami           = module.vpc.ami_id
  subnet_id     = module.vpc.subnet_id
  instance_type = "t2.micro"
  key_name                    = "PrivateKey"
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  tags = {
      Name = var.ec2_name
  }
}
