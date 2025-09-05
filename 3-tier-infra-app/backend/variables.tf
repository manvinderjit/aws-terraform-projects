variable "aws_region" {
  description = "the aws region to deploy the resources in"
  type        = string
  default     = "us-east-2"
}

variable "ec2_key_name" {
  description = "Name of EC2 key pair"
  type        = string
  default     = "aws-labs-becloudready"
}

variable "instance_type" {
  description = "type of ec2 instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "ec2_ami_id_backend" {
  description = "ami to be used for launching ec2"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS endpoint for backend to connect to"
  type        = string
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

variable "tfstate_bucket" {}
variable "base_tfstate_key" {}
variable "tfstate_region" {}
variable "tfstate_lock_table" {}
