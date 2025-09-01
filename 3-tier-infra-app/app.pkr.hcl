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
  default = "my-app-ami"
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
      "sudo yum install -y git nodejs npm",
      "cd /home/ec2-user",
      "git clone https://github.com/manvinderjit/2023-TOP-Project-Shopping-Cart.git app",
      "cd app",
      "npm install",
      "VITE_API_BASE_URL=\"https://ia.manvinderjit.com/\" npm run build",
      "sudo npm install -g serve",      
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest.json"
  }
}