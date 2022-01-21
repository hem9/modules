output "subnet_id" {
  value = aws_subnet.this.id
}

output "ami_id" {
  value = data.aws_ssm_parameter.this.value
}

output "myvpc" {
    value = aws_vpc.this.id
}