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

# Route table associations - public
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

# Route table associations - private
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
