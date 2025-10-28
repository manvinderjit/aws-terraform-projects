output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.eks_msk_rds_app_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [
    aws_subnet.eks_msk_rds_app_subnet_public_1.id,
    aws_subnet.eks_msk_rds_app_subnet_public_2.id
  ]
}

output "private_eks_subnet_ids" {
  description = "IDs of the private EKS subnets"
  value       = [
    aws_subnet.eks_msk_rds_app_subnet_private_eks_1.id,
    aws_subnet.eks_msk_rds_app_subnet_private_eks_2.id
  ]
}

output "private_msk_subnet_ids" {
  description = "IDs of the private MSK subnets"
  value       = [
    aws_subnet.eks_msk_rds_app_subnet_private_msk_1.id,
    aws_subnet.eks_msk_rds_app_subnet_private_msk_2.id
  ]
}

output "rds_subnet_ids" {
  description = "IDs of the RDS subnets"
  value       = [
    aws_subnet.eks_msk_rds_app_subnet_rds_1.id,
    aws_subnet.eks_msk_rds_app_subnet_rds_2.id
  ]
}