provider "aws" {
    region = var.aws_region
    # Provide default tags to identify all resources
    default_tags {
      tags = {      
        ManagedBy = "GitAwsTerraformProjects"
        Project   = "eks-msk-rds-app"
      }
    }
}

resource "aws_vpc" "eks_msk_rds_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-msk-rds-app-vpc"
  }
}

resource "aws_internet_gateway" "eks_msk_rds_app_igw" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id
  tags = {
    Name = "eks-msk-rds-app-igw"
  }
}

resource "aws_route_table" "eks_msk_rds_app_public_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_msk_rds_app_igw.id
  }
  tags = {
    Name = "eks-msk-rds-app-route-table-public"
  }
}

resource "aws_route_table" "eks_msk_rds_app_private_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id

  tags = {
    Name = "eks-msk-rds-app-route-table-private"
  }
}

resource "aws_route_table" "eks_msk_rds_app_msk_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id
  tags = {
    Name = "eks-msk-rds-app-route-table-msk"
  }
}

resource "aws_route_table" "eks_msk_rds_app_rds_rt" {
  vpc_id = aws_vpc.eks_msk_rds_app_vpc.id

  tags = {
    Name = "eks-msk-rds-app-route-table-rds"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_public_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-msk-rds-app-subnet-public-1"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_public_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-msk-rds-app-subnet-public-2"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_eks_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-msk-rds-app-subnet-private-eks-1"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_eks_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-msk-rds-app-subnet-private-eks-2"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_msk_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-msk-rds-app-subnet-private-msk-1"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_private_msk_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-msk-rds-app-subnet-private-msk-2"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_rds_1" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.7.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-msk-rds-app-subnet-rds-1"
  }
}

resource "aws_subnet" "eks_msk_rds_app_subnet_rds_2" {
  vpc_id                  = aws_vpc.eks_msk_rds_app_vpc.id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-msk-rds-app-subnet-rds-2"
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
    Name = "eks-msk-rds-app-ngw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.eks_msk_rds_app_subnet_public_1.id
  tags = {
    Name = "eks-msk-rds-app-nat"
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

# Security Groups
resource "aws_security_group" "eks_msk_rds_app_sg_eks_node" {
  name        = "eks-msk-rds-app-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = aws_vpc.eks_msk_rds_app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from my IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-msk-rds-app-sg-eks-node"
  }
}

resource "aws_security_group" "eks_msk_rds_app_sg_rds" {
  name        = "eks-msk-rds-app-sg-rds"
  description = "Allow MySQL from EC2"
  vpc_id      = aws_vpc.eks_msk_rds_app_vpc.id

  ingress {
    description     = "MySQL access from EKS Nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_msk_rds_app_sg_eks_node.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "eks-msk-rds-app-rds-db-sbnt-grp"
  subnet_ids = [
    aws_subnet.eks_msk_rds_app_subnet_rds_1.id,
    aws_subnet.eks_msk_rds_app_subnet_rds_2.id
  ]
}

# RDS Database
resource "aws_db_instance" "default" {
  identifier              = "terraform-db"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.42"
  instance_class          = "db.t4g.micro"    
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.eks_msk_rds_app_sg_rds.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0
  tags = {
    Name = "eks-msk-rds-app-rds-terraform-db"
  }
}

# EKS Cluster Role
resource "aws_iam_role" "eks_msk_rds_app_eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "eks-msk-rds-app-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_msk_rds_app_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_msk_rds_app_eks_cluster_role.name
}


resource "aws_eks_cluster" "eks_msk_rds_app_eks_cluster" {
  name     = "eks-msk-rds-app-cluster"
  role_arn = aws_iam_role.eks_msk_rds_app_eks_cluster_role.arn
  version  = "1.33"

  vpc_config {
    subnet_ids              = [
      aws_subnet.eks_msk_rds_app_subnet_private_eks_1.id,
      aws_subnet.eks_msk_rds_app_subnet_private_eks_2.id
    ]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }
  upgrade_policy {    
    support_type = "STANDARD" 
  }

  enabled_cluster_log_types = [] # No logs enabled
  tags = {
    Name = "eks-msk-rds-app-cluster"
  }

  # Disable delete protection
  deletion_protection = false
 
}

# Amazon VPC CNI (Networking)
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "vpc-cni"
  depends_on = [aws_eks_cluster.eks_msk_rds_app_eks_cluster]
}

# Kube Proxy (Networking)
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "kube-proxy"
  depends_on = [aws_eks_cluster.eks_msk_rds_app_eks_cluster]
}

# EKS Pod Identity Agent (Security)
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "eks-pod-identity-agent"
  depends_on = [aws_eks_cluster.eks_msk_rds_app_eks_cluster]
}

# EKS Node Monitoring Agent (Observability)
resource "aws_eks_addon" "node_monitoring_agent" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "eks-node-monitoring-agent"
  depends_on = [aws_eks_cluster.eks_msk_rds_app_eks_cluster]
}


resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "eks-node-group-role"
  }
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  node_group_name = "eks-t3micro-ng"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [
    aws_subnet.eks_msk_rds_app_subnet_private_eks_1.id,
    aws_subnet.eks_msk_rds_app_subnet_private_eks_2.id
  ]
  instance_types  = ["t3.micro"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  ami_type             = "AL2023_x86_64_STANDARD"
  disk_size            = 20              
  capacity_type        = "ON_DEMAND"
  force_update_version = true

  tags = {
    Name = "eks-node-group-t3micro"
  }
}

# CoreDNS (Networking)
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "coredns"
  depends_on = [ aws_eks_node_group.eks_nodes ]
}

# Metrics Server (Observability)
resource "aws_eks_addon" "metrics_server" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "metrics-server"
  depends_on = [ aws_eks_node_group.eks_nodes ]
}

# External DNS (Networking)
resource "aws_eks_addon" "external_dns" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "external-dns"
  depends_on = [ aws_eks_node_group.eks_nodes ]
}