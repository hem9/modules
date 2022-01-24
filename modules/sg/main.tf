
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = var.vpcid
  
}

resource "aws_route_table" "prod-public-crt" {
  vpc_id = var.vpcid

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.prod-igw.id
  }


}

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = var.subnetid
  route_table_id = aws_route_table.prod-public-crt.id
}
#Create SG for allowing TCP/22 from anywhere, THIS IS FOR TESTING ONLY
resource "aws_security_group" "this" {
  name        = "${terraform.workspace}-sg"
  description = "Allow TCP/22"
  vpc_id      = var.vpcid
  dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SSH-HTTP-securitygroup"
  }
}


