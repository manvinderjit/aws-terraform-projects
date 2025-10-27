output "registered_targets" {
  description = "List of registered target IDs"
  value       = data.aws_instances.eks_nodes.ids
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = var.target_group_arn
}