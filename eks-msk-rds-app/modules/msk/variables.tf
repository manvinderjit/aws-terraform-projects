variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "msk_subnet_ids" {
  description = "List of subnet IDs for MSK"
  type        = list(string)
}

variable "eks_node_security_group_id" {
  description = "Security group ID of the EKS nodes"
  type        = string
}

variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string
  default     = "3.8.x"
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster"
  type        = number
  default     = 2
}

variable "broker_instance_type" {
  description = "Specify the instance type to use for the kafka brokers"
  type        = string
  default     = "kafka.t3.small"
}

variable "broker_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node"
  type        = number
  default     = 10
}

variable "client_broker_encryption" {
  description = "Encryption setting for data in transit between clients and brokers"
  type        = string
  default     = "PLAINTEXT"
}

variable "in_cluster_encryption" {
  description = "Whether data communication among broker nodes is encrypted"
  type        = bool
  default     = false
}
