variable "aws_region" {
    description = "the aws region to deploy the resources in"
    type = string
    default = "us-east-2"
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