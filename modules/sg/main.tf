

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
