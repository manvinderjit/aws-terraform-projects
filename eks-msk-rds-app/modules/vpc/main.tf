resource "aws_vpc" "eks_msk_rds_app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "eks_msk_rds_app_igw" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "eks_msk_rds_app_public_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_msk_rds_app_igw.id
  }
  tags = {
    Name = "${var.project_name}-route-table-public"
  }
}

resource "aws_route_table" "eks_msk_rds_app_private_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id

  tags = {
    Name = "${var.project_name}-route-table-private"
  }
}

resource "aws_route_table" "eks_msk_rds_app_msk_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id
  tags = {
    Name = "${var.project_name}-route-table-msk"
  }
}

resource "aws_route_table" "eks_msk_rds_app_rds_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id

  tags = {
    Name = "${var.project_name}-route-table-rds"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_public_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "${var.project_name}-subnet-public-1"
    "kubernetes.io/role/elb"                   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_public_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name                                        = "${var.project_name}-subnet-public-2"
    "kubernetes.io/role/elb"                   = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_eks_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.private_eks_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name                                        = "${var.project_name}-subnet-private-eks-1"
    "kubernetes.io/role/internal-elb"          = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_eks_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.private_eks_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name                                        = "${var.project_name}-subnet-private-eks-2"
    "kubernetes.io/role/internal-elb"          = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_msk_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.private_msk_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-subnet-private-msk-1"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_msk_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.private_msk_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-subnet-private-msk-2"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_rds_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.rds_subnet_cidrs[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-subnet-rds-1"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_rds_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = var.rds_subnet_cidrs[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-subnet-rds-2"
  }
}

resource "aws_route_table_association" "eks_msk_rds_app_public_association_1" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_public_1.id
  route_table_id = aws_route_table.eks_msk_rds_app_public_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_public_association_2" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_public_2.id
  route_table_id = aws_route_table.eks_msk_rds_app_public_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_private_association_1" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_private_eks_1.id
  route_table_id = aws_route_table.eks_msk_rds_app_private_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_private_association_2" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_private_eks_2.id
  route_table_id = aws_route_table.eks_msk_rds_app_private_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_rds_association_1" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_rds_1.id
  route_table_id = aws_route_table.eks_msk_rds_app_rds_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_rds_association_2" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_rds_2.id
  route_table_id = aws_route_table.eks_msk_rds_app_rds_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_msk_association_1" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_private_msk_1.id
  route_table_id = aws_route_table.eks_msk_rds_app_msk_rt.id
}

resource "aws_route_table_association" "eks_msk_rds_app_msk_association_2" {
  subnet_id      = aws_subnet.eks_msk_rds_app_subnet_private_msk_2.id
  route_table_id = aws_route_table.eks_msk_rds_app_msk_rt.id
}

# Nat Gateways
resource "aws_eip" "nat_gw" {
  tags = {
    Name = "${var.project_name}-ngw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.eks_msk_rds_app_subnet_public_1.id
  tags = {
    Name = "${var.project_name}-nat"
  }
}

resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.eks_msk_rds_app_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route" "msk_to_nat" {
  route_table_id         = aws_route_table.eks_msk_rds_app_msk_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}
