resource "aws_security_group" "eks_msk_rds_app_sg_msk" {
  name        = "${var.project_name}-sg-msk"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
    description     = "Allow Kafka traffic from EKS nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg-msk"
  }
}

resource "aws_msk_cluster" "eks_msk_rds_app_msk_cluster" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  
  broker_node_group_info {
    instance_type   = var.broker_instance_type    
    client_subnets  = var.msk_subnet_ids
    security_groups = [aws_security_group.eks_msk_rds_app_sg_msk.id]

     storage_info {
      ebs_storage_info {        
        volume_size = var.broker_volume_size
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = var.client_broker_encryption
      in_cluster    = var.in_cluster_encryption
    }
  }  

  tags = {
    Name = var.cluster_name
  }
}