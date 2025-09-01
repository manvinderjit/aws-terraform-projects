provider "aws" {
    region = var.aws_region
    # Provide default tags to identify all resources
    default_tags {
      tags = {      
        ManagedBy = "GitAwsTerraformProjects"
        Project   = "three-tier-infra-app"
      }
    }
}

resource "aws_vpc" "three_tier_infra_app_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "3-tier-infra-app-vpc"
  }
}

resource "aws_internet_gateway" "three_tier_infra_app_igw" {
  vpc_id = aws_vpc.three_tier_infra_app_vpc.id
  tags = {
    Name = "three-tier-infra-app-igw"
  }
}

resource "aws_route_table" "three_tier_infra_app_public_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_infra_app_igw.id
  }
  tags = {
    Name = "three-tier-infra-app-route-table-public"
  }
}

resource "aws_route_table" "three_tier_infra_app_private_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_vpc.id

  tags = {
    Name = "three-tier-infra-app-route-table-private"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_public_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-subnet-public-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_public_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-subnet-public-2"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_public_3" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-subnet-public-3"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_private_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.4.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-subnet-private-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_private_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.5.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-subnet-private-2"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_private_3" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.6.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-subnet-private-3"
  }
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_public_1.id
  route_table_id = aws_route_table.three_tier_infra_app_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_public_2.id
  route_table_id = aws_route_table.three_tier_infra_app_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_3" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_public_3.id
  route_table_id = aws_route_table.three_tier_infra_app_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_private_1.id
  route_table_id = aws_route_table.three_tier_infra_app_private_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_private_2.id
  route_table_id = aws_route_table.three_tier_infra_app_private_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_3" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_private_3.id
  route_table_id = aws_route_table.three_tier_infra_app_private_rt.id
}

# Security groups for ec2 instances
resource "aws_security_group" "three_tier_infra_app_public_ec2_sg" {
  name        = "three-tier-infra-app-public-ec2-sg"
  description = "Allow SSH from the internet"
  vpc_id      = aws_vpc.three_tier_infra_app_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Http web traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "three_tier_infra_app_private_ec2_sg" {
  name        = "three-tier-infra-app-private-ec2-sg"
  description = "Allow SSH from public EC2 only"
  vpc_id      = aws_vpc.three_tier_infra_app_vpc.id

  ingress {
    description     = "SSH from public EC2"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_app_public_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_ec2" {
  ami                         = var.ec2_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.three_tier_infra_app_subnet_public_1.id
  vpc_security_group_ids      = [aws_security_group.three_tier_infra_app_public_ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.ec2_key_name

  user_data = <<-EOF
    #!/bin/bash
    cd /home/ec2-user/app
    nohup serve -s dist -l 0.0.0.0:3000 > /home/ec2-user/serve.log 2>&1 &
  EOF
}