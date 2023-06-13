output "aws_ami_name" {
  description = "The name of the ami"
  value = data.aws_ami.ubuntu.name
}

output "vpc_id" {
  description = "ID of the created vpc"
  value = aws_vpc.cybersift.id
}

