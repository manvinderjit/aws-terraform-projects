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
