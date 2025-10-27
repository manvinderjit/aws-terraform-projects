variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "node_port" {
  description = "NodePort to register with ALB"
  type        = number
}