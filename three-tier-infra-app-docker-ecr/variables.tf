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
  default     = "t3.nano"
}