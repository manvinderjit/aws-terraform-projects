packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "ami_name_app" {
  type    = string
  default = "three-tier-ami-be-app"
}

variable "rds_endpoint" {
  type = string
}

# Backend Source
source "amazon-ebs" "backend_app" {
  region                  = "us-east-2"
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["137112412989"] # Amazon as the official owner
    most_recent = true
  }

  instance_type          = "t2.micro"
  ssh_username           = "ec2-user"
  ami_name = "${var.ami_name_app}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

# Backend build
build {
  name    = "backend-app-ami"
  sources = ["source.amazon-ebs.backend_app"]

  provisioner "shell" {
    inline = [
      "echo 'export DB_URL=${var.rds_endpoint}' | sudo tee -a /etc/profile.d/rds.sh",
      "sudo yum update -y",      
      "sudo yum install -y git java-21-amazon-corretto-devel wget unzip",
      "cd /home/ec2-user",      
      "sudo mkdir tmp tmp/app",
      "sudo git clone https://github.com/manvinderjit/react-springboot-test-app.git tmp/app",
      "sudo mkdir -p app",
      "sudo cp -r tmp/app/backend/. app/",
      "cd app",
      "sudo chmod +x mvnw",
      "sudo ./mvnw clean package -DskipTests",
      "sudo rm -rf /home/ec2-user/tmp/app/"

      # The jar file will be in /app/target/*.jar    
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest-backend.json"
  }
}
