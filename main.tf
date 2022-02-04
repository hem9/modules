variable "main_region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.main_region
}

module "vpc" {
  source          = "./modules/vpc"
  cidrBlock       = "172.16.0.0/16"
  subnetCidrBlock = "172.16.1.0/24"
  region          = var.main_region
}
module "sg" {
  source   = "./modules/sg"
  vpcid    = module.vpc.myvpc
  region   = var.main_region
  subnetid = module.vpc.mysubnet
}
resource "aws_instance" "my_instance" {
  ami                         = module.vpc.ami_id
  subnet_id                   = module.vpc.subnet_id
  instance_type               = "t2.micro"
  key_name                    = "PrivateKey"
  associate_public_ip_address = true
  iam_instance_profile        = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids      = [module.sg.security_group_id]
  user_data                   = fileexists("script.sh") ? file("script.sh") : null
  connection {
    user        = var.EC2_USER
    private_key = file("${var.PRIVATE_KEY_PATH}")
  }
  tags = {
    Name       = var.ec2_name
    SSHmanaged = var.bool_ssm
  }
}

output "instace_ip" {
  value = aws_instance.my_instance.*.public_ip
}
