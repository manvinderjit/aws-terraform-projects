# Security Groups
resource "aws_security_group" "eks_msk_rds_app_sg_eks_node" {
  name        = "${var.project_name}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

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
    Name = "${var.project_name}-sg-eks-node"
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
    Name = "${var.project_name}-eks-cluster-role"
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
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_msk_rds_app_eks_cluster_role.arn
  version  = var.cluster_version

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  vpc_config {
    subnet_ids              = var.private_eks_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  upgrade_policy {
    support_type = "STANDARD"
  }

  enabled_cluster_log_types = [] # No logs enabled
  tags = {
    Name = var.cluster_name
  }

  # Disable delete protection
  deletion_protection = false
}

# The access entry resource no longer needs the kubernetes_groups argument
resource "aws_eks_access_entry" "eks_admin_user" {
  cluster_name  = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  principal_arn = var.eks_admin_user_arn
  depends_on = [
    aws_eks_cluster.eks_msk_rds_app_eks_cluster
  ]
}

# This new resource associates the admin policy with the access entry
resource "aws_eks_access_policy_association" "eks_admin_policy_association" {
  cluster_name  = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  principal_arn = aws_eks_access_entry.eks_admin_user.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

# GitHub Actions role access entry (for CI/CD)
resource "aws_eks_access_entry" "github_actions_role" {
  count         = var.github_actions_role_arn != "" ? 1 : 0
  cluster_name  = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  principal_arn = var.github_actions_role_arn
  depends_on = [
    aws_eks_cluster.eks_msk_rds_app_eks_cluster
  ]
}

# GitHub Actions role policy association
resource "aws_eks_access_policy_association" "github_actions_policy_association" {
  count         = var.github_actions_role_arn != "" ? 1 : 0
  cluster_name  = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  principal_arn = aws_eks_access_entry.github_actions_role[0].principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
}

# Amazon VPC CNI (Networking)
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "vpc-cni"
  depends_on   = [aws_eks_cluster.eks_msk_rds_app_eks_cluster]
}

# Kube Proxy (Networking)
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "kube-proxy"
  depends_on   = [aws_eks_cluster.eks_msk_rds_app_eks_cluster]
}

# Removed optional add-ons for cost optimization:
# - pod-identity-agent: Not using Pod Identity in this project
# - node-monitoring-agent: Not using advanced CloudWatch monitoring

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
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.private_eks_subnet_ids
  instance_types  = var.node_instance_types

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  ami_type             = var.node_ami_type
  disk_size            = var.node_disk_size
  capacity_type        = var.node_capacity_type
  force_update_version = var.force_update_version



  tags = {
    Name = var.node_group_name
  }
}

# CoreDNS (Networking)
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_msk_rds_app_eks_cluster.name
  addon_name   = "coredns"
  depends_on   = [aws_eks_node_group.eks_nodes]
}

# Removed optional add-ons for cost optimization:
# - metrics-server: Not using HPA/VPA autoscaling
# - external-dns: Using ALB DNS name directly, no Route53 automation needed
