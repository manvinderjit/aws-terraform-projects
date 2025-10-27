# VPC and Networking Module
module "vpc" {
  source = "./modules/vpc"

  project_name   = "eks-msk-rds-app"
  cluster_name   = "eks-msk-rds-app-cluster"
  vpc_cidr       = "10.0.0.0/16"
  
  availability_zones = ["us-east-2a", "us-east-2b"]
  
  public_subnet_cidrs        = ["10.0.1.0/24", "10.0.2.0/24"]
  private_eks_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
  private_msk_subnet_cidrs   = ["10.0.5.0/24", "10.0.6.0/24"]
  rds_subnet_cidrs           = ["10.0.7.0/24", "10.0.8.0/24"]
}

# EKS Cluster Module
module "eks" {
  source = "./modules/eks"

  project_name            = "eks-msk-rds-app"
  vpc_id                  = module.vpc.vpc_id
  private_eks_subnet_ids  = module.vpc.private_eks_subnet_ids
  cluster_name            = "eks-msk-rds-app-cluster"
  cluster_version         = "1.33"
  eks_admin_user_arn          = var.eks_admin_user_arn

  # Node group configuration
  node_group_name         = "eks-t3small-ng"
  node_instance_types     = ["t3.small"]
  node_desired_size       = 2
  node_max_size           = 2
  node_min_size           = 2
  node_ami_type           = "AL2023_x86_64_STANDARD"
  node_disk_size          = 20
  node_capacity_type      = "ON_DEMAND"
  force_update_version    = false

  depends_on = [module.vpc]
}
