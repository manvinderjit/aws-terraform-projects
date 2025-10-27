# VPC and Networking Module
module "vpc" {
  source = "./modules/vpc"

  project_name = "eks-msk-rds-app"
  cluster_name = "eks-msk-rds-app-cluster"
  vpc_cidr     = "10.0.0.0/16"

  availability_zones = ["us-east-2a", "us-east-2b"]

  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_eks_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  private_msk_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
  rds_subnet_cidrs         = ["10.0.7.0/24", "10.0.8.0/24"]
}

# EKS Cluster Module
module "eks" {
  source = "./modules/eks"

  project_name           = "eks-msk-rds-app"
  vpc_id                 = module.vpc.vpc_id
  private_eks_subnet_ids = module.vpc.private_eks_subnet_ids
  cluster_name           = "eks-msk-rds-app-cluster"
  cluster_version        = "1.33"
  eks_admin_user_arn     = var.eks_admin_user_arn

  # Node group configuration
  node_group_name      = "eks-t3small-ng"
  node_instance_types  = ["t3.small"]
  node_desired_size    = 2
  node_max_size        = 2
  node_min_size        = 2
  node_ami_type        = "AL2023_x86_64_STANDARD"
  node_disk_size       = 20
  node_capacity_type   = "ON_DEMAND"
  force_update_version = false

  depends_on = [module.vpc]
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  project_name                  = "eks-msk-rds-app"
  vpc_id                        = module.vpc.vpc_id
  rds_subnet_ids                = module.vpc.rds_subnet_ids
  eks_node_security_group_id    = module.eks.node_security_group_id
  eks_cluster_security_group_id = module.eks.cluster_security_group_id

  # Database configuration
  db_identifier           = "terraform-db"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.42"
  instance_class          = "db.t4g.micro"
  db_username             = var.db_username
  db_password             = var.db_password
  db_name                 = var.db_name
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0

  tags = {
    ManagedBy = "GitAwsTerraformProjects"
    Project   = "eks-msk-rds-app"
  }

  depends_on = [module.vpc, module.eks]
}

# MSK Module
module "msk" {
  source = "./modules/msk"

  project_name                  = "eks-msk-rds-app"
  vpc_id                        = module.vpc.vpc_id
  msk_subnet_ids                = module.vpc.private_msk_subnet_ids
  eks_node_security_group_id    = module.eks.node_security_group_id  

  # MSK configuration
  cluster_name             = "eks-msk-rds-app-msk-cluster"
  kafka_version            = "3.8.x"
  number_of_broker_nodes   = 2
  broker_instance_type     = "kafka.t3.small"
  broker_volume_size       = 10
  client_broker_encryption = "PLAINTEXT"
  in_cluster_encryption    = false

  depends_on = [module.vpc, module.eks]  
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  project_name          = "eks-msk-rds-app"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  frontend_port         = 30080
  eks_security_group_id = module.eks.node_security_group_id

  depends_on = [module.vpc, module.eks]
}
