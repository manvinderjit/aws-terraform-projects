provider "aws" {
    region = "us-east-2"
    default_tags {
      tags = {      
        ManagedBy = "GitAwsTerraformProjects"
        Project   = "ec2-ami-ec2"
      }
    }
}

# Create a Security Group to control access to ec2
resource "aws_security_group" "web_sg" {
  name        = "ec2-ami-ec2-web-sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

# create an iam role for ec2 to access s3
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-ami-ec2-s3-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# attach s3 readonly permissions to the iam role
resource "aws_iam_role_policy_attachment" "attach_s3_access" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# attach the iam role to the ec2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-ami-ec2-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}

# Deploy first EC2
resource "aws_instance" "web_server" {
  ami                         = "ami-0b016c703b95ecbe4"
  instance_type               = "t2.micro"
  key_name                    = var.ec2_key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  security_groups             = [aws_security_group.web_sg.name]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              echo "I was created in the first ec2" > /home/ec2-user/creation-info.txt
              chown ec2-user:ec2-user /home/ec2-user/creation-info.txt
            EOF

  tags = {
    Name = "WebServer"
  }
}

# Create an ami from the deployed EC2 instance
resource "aws_ami_from_instance" "web_server_ami" {
  name               = "ec2-ami-ec2-web-server-ami"
  source_instance_id = aws_instance.web_server.id
  depends_on         = [aws_instance.web_server]

  lifecycle {
    create_before_destroy = true
  }
}

# Use the created ami to deploy another ec2 instance
resource "aws_instance" "web_server_from_ami" {
  ami                    = aws_ami_from_instance.web_server_ami.id
  instance_type          = "t2.micro"  
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  security_groups        = [aws_security_group.web_sg.name]
  associate_public_ip_address = true

  tags = {
    Name = "WebServerClonedUsingAMI"
  }
}
