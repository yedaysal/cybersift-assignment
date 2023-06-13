resource "aws_vpc" "cybersift" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "cybersift-vpc"
  }
}

resource "aws_subnet" "cybersift" {
  vpc_id = aws_vpc.cybersift.id
  cidr_block = "172.16.10.0/24"
  availability_zone = var.region_a
    
  tags = {
    Name = "cybersift-subnet"
  }
}

resource "aws_internet_gateway" "cybersift" {
  vpc_id = aws_vpc.cybersift.id

  tags = {
    Name = "cybersift-vpc-internet-gw"
  }
}

resource "aws_default_route_table" "cybersift" {
  default_route_table_id = aws_vpc.cybersift.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cybersift.id
  }

  tags = {
    Name = "cybersift-vpc-route-table"
  }
}
