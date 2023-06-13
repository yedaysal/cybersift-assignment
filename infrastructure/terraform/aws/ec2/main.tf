resource "aws_s3_bucket" "cybersift" {
  bucket = "cybersift-terraform-state"

  tags = {
    Name        = "CyberSift Terraform State"
    Environment = "Dev"
  }
}

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

resource "aws_default_security_group" "cybersift" {
  vpc_id = aws_vpc.cybersift.id

  ingress {
    protocol = -1
    self = true
    from_port = 0
    to_port = 0
  }

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kibana"
    from_port = 5601
    to_port = 5601
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cybersift-security-group"
  }
}

resource "aws_network_interface" "cybersift" {
  subnet_id = aws_subnet.cybersift.id
  private_ips = ["172.16.10.100"]
  security_groups = [ "${aws_default_security_group.cybersift.id}" ]

  tags = {
    Name = "cybersift-instance-primary-nic"
  }
}

resource "aws_key_pair" "cybersift" {
  key_name = "cybersift-pub-key"
  public_key = var.public_key
}

resource "aws_instance" "cybersift" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  network_interface {
    network_interface_id = aws_network_interface.cybersift.id
    device_index = 0
  }

  key_name = aws_key_pair.cybersift.key_name

  tags = {
    Name = "cybersift"
  }
}

resource "aws_eip" "cybersift" {
  instance = aws_instance.cybersift.id
  domain = "vpc"

  tags = {
    Name = "cybersift-instance-public-ip"
  }
}
