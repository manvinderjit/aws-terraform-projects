# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

# EKS Outputs
output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

# RDS Outputs
output "db_instance_endpoint" {
  description = "The RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_port" {
  description = "The database port"
  value       = module.rds.db_instance_port
}

# MSK Outputs
output "msk_cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = module.msk.cluster_arn
}

output "msk_bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = module.msk.bootstrap_brokers
}

output "msk_zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
  value       = module.msk.zookeeper_connect_string
}

# Load Balancer Access
output "load_balancer_instructions" {
  description = "Instructions to get the LoadBalancer URL"
  value       = "Run: kubectl get service service-kafka-project-frontend-lb -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "public_subnet_ids" {
  description = "List of public subnet IDs for ALB configuration"
  value       = module.vpc.public_subnet_ids
}

# Instructions for getting ALB DNS name
output "ingress_instructions" {
  description = "Instructions to get the ALB DNS name"
  value       = "Run: kubectl get ingress kafka-project-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
