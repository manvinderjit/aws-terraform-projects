output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = aws_msk_cluster.eks_msk_rds_app_msk_cluster.arn
}

output "bootstrap_brokers" {
  description = "Plaintext connection host:port pairs"
  value       = aws_msk_cluster.eks_msk_rds_app_msk_cluster.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "TLS connection host:port pairs"
  value       = aws_msk_cluster.eks_msk_rds_app_msk_cluster.bootstrap_brokers_tls
}

output "zookeeper_connect_string" {
  description = "A comma separated list of one or more hostname:port pairs to use to connect to the Apache Zookeeper cluster"
  value       = aws_msk_cluster.eks_msk_rds_app_msk_cluster.zookeeper_connect_string
}

output "security_group_id" {
  description = "ID of the MSK security group"
  value       = aws_security_group.eks_msk_rds_app_sg_msk.id
}