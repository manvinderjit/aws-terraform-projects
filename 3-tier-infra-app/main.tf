provider "aws" {
    region = var.aws_region
    # Provide default tags to identify all resources
    default_tags {
      tags = {      
        ManagedBy = "GitAwsTerraformProjects"
        Project   = "three-tier-infra-app"
      }
    }
}

resource "aws_vpc" "three_tier_infra_app_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "3-tier-infra-app-vpc"
  }
}

resource "aws_internet_gateway" "three_tier_infra_app_igw" {
  vpc_id = aws_vpc.three_tier_infra_app_vpc.id
  tags = {
    Name = "three-tier-infra-app-igw"
  }
}

resource "aws_route_table" "three_tier_infra_app_public_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.three_tier_infra_app_igw.id
  }
  tags = {
    Name = "three-tier-infra-app-route-table-public"
  }
}

resource "aws_route_table" "three_tier_infra_app_private_rt" {
  vpc_id = aws_vpc.three_tier_infra_app_vpc.id

  tags = {
    Name = "three-tier-infra-app-route-table-private"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_public_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-subnet-public-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_public_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-subnet-public-2"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_public_3" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.3.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "three-tier-infra-app-subnet-public-3"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_private_1" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.4.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-subnet-private-1"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_private_2" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.5.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-subnet-private-2"
  }
}

resource "aws_subnet" "three_tier_infra_app_subnet_private_3" {
  vpc_id                  = aws_vpc.three_tier_infra_app_vpc.id
  cidr_block              = "192.168.6.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = false
  tags = {
    Name = "three-tier-infra-app-subnet-private-3"
  }
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_public_1.id
  route_table_id = aws_route_table.three_tier_infra_app_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_public_2.id
  route_table_id = aws_route_table.three_tier_infra_app_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_public_association_3" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_public_3.id
  route_table_id = aws_route_table.three_tier_infra_app_public_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_1" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_private_1.id
  route_table_id = aws_route_table.three_tier_infra_app_private_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_2" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_private_2.id
  route_table_id = aws_route_table.three_tier_infra_app_private_rt.id
}

resource "aws_route_table_association" "three_tier_infra_app_private_association_3" {
  subnet_id      = aws_subnet.three_tier_infra_app_subnet_private_3.id
  route_table_id = aws_route_table.three_tier_infra_app_private_rt.id
}

# Security groups for alb
resource "aws_security_group" "three_tier_infra_app_alb_sg" {
  name        = "three-tier-infra-app-alb-sg"
  description = "Allow HTTP inbound from anywhere"
  vpc_id      = aws_vpc.three_tier_infra_app_vpc.id

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

# Security groups for ec2 instances
resource "aws_security_group" "three_tier_infra_appserver_ec2_sg" {
  name        = "three-tier-infra-appserver-ec2-sg"
  description = "Allow SSH from the internet and local traffic on port 3000"
  vpc_id      = aws_vpc.three_tier_infra_app_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_app_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "three_tier_infra_app_private_ec2_sg" {
  name        = "three-tier-infra-app-private-ec2-sg"
  description = "Allow SSH from public EC2 only"
  vpc_id      = aws_vpc.three_tier_infra_app_vpc.id

  ingress {
    description     = "SSH from public EC2"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.three_tier_infra_appserver_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "three_tier_infra_app_ws_alb" {
  name               = "three-tier-infra-app-ws-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.three_tier_infra_app_alb_sg.id]
  subnets            = [
    aws_subnet.three_tier_infra_app_subnet_public_1.id,
    aws_subnet.three_tier_infra_app_subnet_public_2.id,
    aws_subnet.three_tier_infra_app_subnet_public_3.id,
  ]
}

resource "aws_lb_target_group" "three_tier_infra_app_ws_tg" {
  name     = "three-tier-infra-app-ws-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.three_tier_infra_app_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.three_tier_infra_app_ws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.three_tier_infra_app_ws_tg.arn
  }
}

resource "aws_placement_group" "app_pg" {
  name     = "three-tier-infra-app-pg"
  strategy = "cluster"
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "three-tier-infra-app-lt-"
  image_id      = var.ec2_ami_id
  instance_type = var.instance_type
  key_name      = var.ec2_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.three_tier_infra_appserver_ec2_sg.id]
    subnet_id                   = null # subnet is specified at ASG level
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    cd /home/ec2-user/app
    serve -s dist -l 3000 &
  EOF
  )

  placement {
    group_name = aws_placement_group.app_pg.name
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "three-tier-infra-app-asg"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [
    aws_subnet.three_tier_infra_app_subnet_public_1.id,
    aws_subnet.three_tier_infra_app_subnet_public_2.id,
    aws_subnet.three_tier_infra_app_subnet_public_3.id,
  ]

  target_group_arns = [aws_lb_target_group.three_tier_infra_app_ws_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "three-tier-infra-app-asg-instance"
    propagate_at_launch = true
  }
}

# Launc EC2 in public subnet
# resource "aws_instance" "public_ec2" {
#   ami                         = var.ec2_ami_id
#   instance_type               = var.instance_type
#   subnet_id                   = aws_subnet.three_tier_infra_app_subnet_public_1.id
#   vpc_security_group_ids      = [aws_security_group.three_tier_infra_app_public_ec2_sg.id]
#   associate_public_ip_address = true
#   key_name                    = var.ec2_key_name

#   user_data = <<-EOF
#     #!/bin/bash
#     cd /home/ec2-user/app
#     serve -s dist -l 3000 &
#   EOF
# }