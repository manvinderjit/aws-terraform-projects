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

variable "ami_name" {
  type    = string
  default = "three-tier-ami-app"
}

source "amazon-ebs" "app" {
  region                  = var.aws_region
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
  ami_name = "${var.ami_name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

build {
  sources = ["source.amazon-ebs.app"]

  provisioner "shell" {
    inline = [

      "sudo yum update -y",      
      "sudo yum install -y git java-21-amazon-corretto-devel wget unzip",
      "cd /home/ec2-user",      
      "sudo mkdir /tmp/app",
      "git clone https://github.com/manvinderjit/react-springboot-test-app.git /tmp/app",
      "sudo mkdir -p /app",
      "sudo cp -r /tmp/app/backend/* /app/",
      "cd /app",
      "sudo chmod +x mvnw",
      "sudo ./mvnw clean package -DskipTests",
      "sudo rm -rf /tmp/app"

      # The jar file will be in /app/target/*.jar               
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest.json"
  }
}