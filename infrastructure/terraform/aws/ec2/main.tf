resource "aws_vpc" "cybersift" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "cybersift-vpc"
  }
}