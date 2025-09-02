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

data "terraform_remote_state" "base_infra" {
  backend = "s3"   # or whatever backend you use (S3/DynamoDB, etc)

  config = {
    bucket         = var.tfstate_bucket
    key            = var.base_tfstate_key  # exact key for base infra tfstate
    region         = "us-east-1"    
  }
}

resource "aws_launch_template" "frontend_lt" {
  name_prefix   = "three-tier-frontend-lt"
  image_id      = var.ec2_ami_id_frontend
  instance_type = var.instance_type
  key_name      = var.ec2_key_name

  vpc_security_group_ids = [
    data.terraform_remote_state.base_infra.outputs.webserver_ec2_security_group_id
  ]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              cd /home/ec2-user/web
              sudo nohup serve -s dist -l 3000 > /dev/null 2>&1 &
              EOF
            )
}

# Auto Scaling Group for Frontend EC2
resource "aws_autoscaling_group" "frontend_asg" {
  name             = "three-tier-frontend-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = data.terraform_remote_state.base_infra.outputs.public_subnet_ids

  launch_template {
    id      = aws_launch_template.frontend_lt.id    
  }

  target_group_arns = [
    data.terraform_remote_state.base_infra.outputs.frontend_target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "three-tier-frontend-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = false
  }
}
