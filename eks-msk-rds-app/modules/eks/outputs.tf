output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.eks_msk_rds_app_eks_cluster.id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_msk_rds_app_eks_cluster.arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_msk_rds_app_eks_cluster.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_eks_cluster.eks_msk_rds_app_eks_cluster.vpc_config[0].cluster_security_group_id
}

output "node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = aws_security_group.eks_msk_rds_app_sg_eks_node.id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.eks_nodes.arn
}

output "node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.eks_nodes.status
}