variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "frontend_port" {
  description = "Port that the frontend application runs on"
  type        = number
  default     = 8081
}

variable "eks_security_group_id" {
  description = "Security group ID of the EKS nodes to allow ALB access"
  type        = string
}
