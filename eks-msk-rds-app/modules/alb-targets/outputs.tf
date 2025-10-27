output "registered_targets" {
  description = "List of registered target IDs"
  value       = aws_lb_target_group_attachment.eks_nodes[*].target_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = var.target_group_arn
}