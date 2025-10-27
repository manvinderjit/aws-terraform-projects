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

variable "node_count" {
  description = "Number of EKS nodes to register with ALB"
  type        = number
  default     = 2
}

variable "node_group_ready" {
  description = "Dependency to ensure node group is ready before registering targets"
  type        = any
  default     = null
}