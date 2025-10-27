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

# Data sources for EKS cluster authentication
data "aws_eks_cluster" "cluster" {
  name = "eks-msk-rds-app-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "eks-msk-rds-app-cluster"
}

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }  
}
