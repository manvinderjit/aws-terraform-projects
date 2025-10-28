output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.default.id
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.default.arn
}

output "db_instance_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.default.hosted_zone_id
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.default.port
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = aws_db_subnet_group.db_subnet_group.id
}

output "db_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.eks_msk_rds_app_sg_rds.id
}