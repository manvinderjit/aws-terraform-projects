output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "vpc_id" {
  description = "VPC ID for the 3-tier infra app"
  value       = aws_vpc.three_tier_infra_app_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    aws_subnet.three_tier_infra_app_subnet_public_1.id,
    aws_subnet.three_tier_infra_app_subnet_public_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.three_tier_infra_app_subnet_private_1.id,
    aws_subnet.three_tier_infra_app_subnet_private_2.id,
  ]
}

output "webserver_ec2_security_group_id" {
  description = "Security Group ID for webserver EC2 instances"
  value       = aws_security_group.three_tier_infra_webserver_ec2_sg.id
}

output "private_ec2_security_group_id" {
  description = "Security Group ID for private EC2 instances (backend)"
  value       = aws_security_group.three_tier_infra_app_private_ec2_sg.id
}

output "frontend_alb_sg_id" {
  description = "Security Group ID for front-end ALB"
  value       = aws_security_group.three_tier_infra_app_fe_alb_sg.id
}

output "rds_subnet_ids" {
  description = "List of RDS subnet IDs"
  value = [
    aws_subnet.three_tier_infra_app_subnet_rds_1.id,
    aws_subnet.three_tier_infra_app_subnet_rds_2.id
  ]
}

output "frontend_alb_arn" {
  description = "ARN of the front-end ALB"
  value       = aws_lb.three_tier_infra_app_ws_alb.arn
}

output "frontend_target_group_arn" {
  description = "ARN of the front-end ALB target group"
  value       = aws_lb_target_group.three_tier_infra_app_ws_tg.arn
}

output "api_target_group_arn" {
  value = aws_lb_target_group.api_tg.arn
}

output "private_alb_dns" {
  value = aws_lb.three_tier_infra_app_api_alb.dns_name
}
