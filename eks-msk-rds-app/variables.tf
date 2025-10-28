variable "aws_region" {
  description = "the aws region to deploy the resources in"
  type        = string
  default     = "us-east-2"
}

variable "eks_admin_user_arn" {
  description = "ARN of the IAM user to grant admin access to the EKS cluster"
  type        = string
}

variable "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role for CI/CD access"
  type        = string
  default     = ""
}


variable "db_username" {
  description = "RDS database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "RDS default database"
  type        = string
  sensitive   = true
}
