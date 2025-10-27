# Security Groups
resource "aws_security_group" "eks_msk_rds_app_sg_rds" {
  name        = "${var.project_name}-sg-rds"
  description = "Allow MySQL from EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL access from EKS Nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg-rds"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-rds-db-sbnt-grp"
  subnet_ids = var.rds_subnet_ids

  tags = {
    Name = "${var.project_name}-rds-db-sbnt-grp"
  }
}

# RDS Database
resource "aws_db_instance" "default" {
  identifier              = var.db_identifier
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class    
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.eks_msk_rds_app_sg_rds.id]
  skip_final_snapshot     = var.skip_final_snapshot
  publicly_accessible     = var.publicly_accessible
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  
  tags = {
    Name = "${var.project_name}-rds-${var.db_identifier}"
  }
}