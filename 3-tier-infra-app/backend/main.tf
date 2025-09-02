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
  backend = "s3"   

  config = {
    bucket         = var.tfstate_bucket
    key            = var.base_tfstate_key  # exact key for base infra tfstate
    region         = "us-east-1"    
  }
}

resource "aws_launch_template" "backend_lt" {
  name_prefix   = "three-tier-backend-lt"
  # image_id      = var.ec2_ami_id_backend
  image_id      =  "ami-04b1b28b8a141830e"
  instance_type = var.instance_type
  key_name      = var.ec2_key_name

  vpc_security_group_ids = [
    data.terraform_remote_state.base_infra.outputs.private_ec2_security_group_id
  ]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              cd /home/ec2-user/app/target
              export DB_URL=jdbc:mysql://${data.terraform_remote_state.base_infra.outputs.rds_endpoint}/${var.db_name}?createDatabaseIfNotExist=true
              export DB_USERNAME=${var.db_username}
              export DB_PASSWORD=${var.db_password}
              nohup java -jar backend-0.0.1-SNAPSHOT.jar > /dev/null 2>&1 &
              EOF
            )
}

resource "aws_autoscaling_group" "backend_asg" {
  name             = "three-tier-backend-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = data.terraform_remote_state.base_infra.outputs.private_subnet_ids

  launch_template {
    id      = aws_launch_template.backend_lt.id    
  }

  target_group_arns = [
    data.terraform_remote_state.base_infra.outputs.api_target_group_arn
  ]

  health_check_type         = "EC2"
  health_check_grace_period = 600

  tag {
    key                 = "Name"
    value               = "three-tier-backend-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = false
  }
}
