output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "private_subnet_ids" {
  value = [
    aws_subnet.three_tier_infra_app_subnet_private_1.id,
    aws_subnet.three_tier_infra_app_subnet_private_2.id,
  ]
}

output "private_ec2_security_group_id" {
  value = aws_security_group.three_tier_infra_app_private_ec2_sg.id
}

output "api_target_group_arn" {
  value = aws_lb_target_group.api_tg.arn
}
