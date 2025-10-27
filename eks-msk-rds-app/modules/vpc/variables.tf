variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster for subnet tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_eks_subnet_cidrs" {
  description = "CIDR blocks for private EKS subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_msk_subnet_cidrs" {
  description = "CIDR blocks for private MSK subnets"
  type        = list(string)
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}

variable "rds_subnet_cidrs" {
  description = "CIDR blocks for RDS subnets"
  type        = list(string)
  default     = ["10.0.7.0/24", "10.0.8.0/24"]
}
