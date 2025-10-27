# Data source to get EKS nodes
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:kubernetes.io/cluster/${var.cluster_name}"
    values = ["owned"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [var.node_group_ready]
}

# Register EKS nodes with ALB target group
resource "aws_lb_target_group_attachment" "eks_nodes" {
  count = min(var.node_count, length(data.aws_instances.eks_nodes.ids))
  
  target_group_arn = var.target_group_arn
  target_id        = data.aws_instances.eks_nodes.ids[count.index]
  port             = var.node_port

  lifecycle {
    create_before_destroy = true
  }
}
