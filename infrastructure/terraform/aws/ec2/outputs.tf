output "aws_ami_name" {
  description = "The name of the ami"
  value = data.aws_ami.ubuntu.name
}

output "vpc_id" {
  description = "ID of the created vpc"
  value = aws_vpc.cybersift.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value = aws_subnet.cybersift.id
}

output "igw_id" {
  description = "ID of the create igw"
  value = aws_internet_gateway.cybersift.id
}

output "route_table_id" {
  description = "ID of the cybersift-vpc default route table"
  value = aws_default_route_table.cybersift.id
}