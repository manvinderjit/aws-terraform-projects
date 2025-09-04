provider "aws" {
    region = var.aws_region
    # Provide default tags to identify all resources
    default_tags {
      tags = {      
        ManagedBy = "GitAwsTerraformProjects"
        Project   = "three-tier-infra-app-ecr"
      }
    }
}

resource "aws_vpc" "three_tier_infra_app_ecr_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "three-tier-infra-app-ecr-vpc-new"
  }
}

resource "aws_internet_gateway" "three_tier_infra_app_ecr_igw" {
  vpc_id = aws_vpc.three_tier_infra_app_ecr_vpc.id
  tags = {
    Name = "three-tier-infra-app-ecr-igw"
  }
}

resource "aws_route_table" "three_tier_infra_app_ecr_public_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_ecr_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_infra_app_ecr_igw.id
  }
  tags = {
    Name = "three-tier-infra-app-ecr-route-table-public"
  }
}

resource "aws_route_table" "three_tier_infra_app_ecr_private_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_ecr_vpc.id

  tags = {
    Name = "three-tier-infra-app-ecr-route-table-private"
  }
}

resource "aws_route_table" "three_tier_infra_app_ecr_rds_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_ecr_vpc.id

  tags = {
    Name = "three-tier-infra-app-ecr-route-table-rds"
  }
}

resource "aws_subnet" "three_tier_infra_app_ecr_subnet_public_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_ecr_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-ecr-subnet-public-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_ecr_subnet_public_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_ecr_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-ecr-subnet-public-2"
  }
}

resource "aws_subnet" "three_tier_infra_app_ecr_subnet_private_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_ecr_vpc.id
  cidr_block              = "192.168.4.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-ecr-subnet-private-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_ecr_subnet_private_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_ecr_vpc.id
  cidr_block              = "192.168.5.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-ecr-subnet-private-2"
  }
}

resource "aws_subnet" "three_tier_infra_app_ecr_subnet_rds_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_ecr_vpc.id
  cidr_block              = "192.168.7.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-ecr-subnet-rds-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_ecr_subnet_rds_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_ecr_vpc.id
  cidr_block              = "192.168.8.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-ecr-subnet-rds-2"
  }
}

# Route table associations - public
resource "aws_route_table_association" "three_tier_infra_app_public_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_ecr_subnet_public_1.id
  route_table_id = aws_route_table.three_tier_infra_app_ecr_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_ecr_subnet_public_2.id
  route_table_id = aws_route_table.three_tier_infra_app_ecr_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_ecr_subnet_private_1.id
  route_table_id = aws_route_table.three_tier_infra_app_ecr_private_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_ecr_subnet_private_2.id
  route_table_id = aws_route_table.three_tier_infra_app_ecr_private_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_rds_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_ecr_subnet_rds_1.id
  route_table_id = aws_route_table.three_tier_infra_app_ecr_rds_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_rds_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_ecr_subnet_rds_2.id
  route_table_id = aws_route_table.three_tier_infra_app_ecr_rds_rt.id
}

# Nat Gateways
resource "aws_eip" "nat_gw" {  
  tags = {
    Name = "three-tier-infra-app-ecr-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.three_tier_infra_app_ecr_subnet_public_1.id
  tags = {
    Name = "three-tier-infra-app-ecr-nat-gw"
  }
}

resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.three_tier_infra_app_ecr_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Security groups for public alb
resource "aws_security_group" "three_tier_infra_app_ecr_fe_alb_sg" {
  name        = "three-tier-infra-app-ecr-fe-alb-sg"
  description = "Allow HTTP inbound from anywhere"
  vpc_id      = aws_vpc.three_tier_infra_app_ecr_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security groups for ec2 - web tier
resource "aws_security_group" "three_tier_infra_app_ecr_web_ec2_sg" {
  name        = "three-tier-infra-app-ecr-web-ec2-sg"
  description = "Allow SSH from the internet and local traffic on port 3000"
  vpc_id      = aws_vpc.three_tier_infra_app_ecr_vpc.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_app_ecr_fe_alb_sg.id]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security groups for ec2 - app tier
resource "aws_security_group" "three_tier_infra_app_ecr_app_ec2_sg" {
  name        = "three-tier-infra-app-ecr-app-ec2-sg"
  description = "Allow access from public EC2 only"
  vpc_id      = aws_vpc.three_tier_infra_app_ecr_vpc.id

  ingress {
    description     = "SSH from public EC2"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_app_ecr_web_ec2_sg.id]
  }

   ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_app_ecr_fe_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "three-tier-infra-app-ecr-sg-rds"
  description = "Allow MySQL from EC2"
  vpc_id      = aws_vpc.three_tier_infra_app_ecr_vpc.id

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_app_ecr_app_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "three-tier-infra-app-ecr-rds-sbnt-grp"
  subnet_ids = [aws_subnet.three_tier_infra_app_ecr_subnet_rds_1.id, aws_subnet.three_tier_infra_app_ecr_subnet_rds_2.id]
}

# RDS Database
resource "aws_db_instance" "three_tier_infra_app_ecr_dbs" {
  identifier              = "three-tier-infra-ecr-db"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.42"
  instance_class          = "db.t4g.micro"    
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0
}

# Application Load Balancer - Frontend
resource "aws_lb" "three_tier_infra_app_ecr_ws_alb" {
  name               = "three-tier-infra-app-ws-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.three_tier_infra_app_ecr_fe_alb_sg.id]
  subnets            = [
    aws_subnet.three_tier_infra_app_ecr_subnet_public_1.id,
    aws_subnet.three_tier_infra_app_ecr_subnet_public_2.id    
  ]
}

resource "aws_lb_target_group" "three_tier_infra_app_ecr_ws_tg" {
  name     = "three-tier-infra-app-ws-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.three_tier_infra_app_ecr_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "3000"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.three_tier_infra_app_ecr_ws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.three_tier_infra_app_ecr_ws_tg.arn
  }
}

resource "aws_lb_target_group" "three_tier_infra_app_ecr_app_tg" {
  name     = "three-tier-infra-app-ecr-app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.three_tier_infra_app_ecr_vpc.id

  health_check {
    path                = "/api/movies"
    protocol            = "HTTP"
    port                = "8080"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener_rule" "api_route" {
  listener_arn = aws_lb_listener.app_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.three_tier_infra_app_ecr_app_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
