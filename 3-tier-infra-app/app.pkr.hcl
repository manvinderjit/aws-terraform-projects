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

variable "ami_name_web" {
  type    = string
  default = "three-tier-ami-fe-web"
}

# Backend Source
source "amazon-ebs" "backend_app" {
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
  ami_name = "${var.ami_name_app}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

# Frontend Source
source "amazon-ebs" "frontend_web" {
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
  ami_name = "${var.ami_name_web}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

# Backend build
build {
  name    = "backend-app-ami"
  sources = ["source.amazon-ebs.backend_app"]

  provisioner "shell" {
    inline = [

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

# Frontend Build
build {
  name    = "frontend-web-ami"
  sources = ["source.amazon-ebs.frontend_web"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git nodejs npm",
      "cd /home/ec2-user",
      "sudo mkdir tmpf tmpf/web",
      "git clone https://github.com/manvinderjit/react-springboot-test-app.git tmpf/web",
      "sudo mkdir -p web",
      "cp -r tmpf/web/frontend/. web/",
      "cd web",
      "npm install",
      "VITE_API_BASE_URL=\"https://ia.manvinderjit.com\" npm run build",
      "sudo npm install -g serve",

      # Install Nginx
      "sudo yum install -y nginx",
      
      # Create nginx config
      "echo 'server { listen 80; location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection \"upgrade\"; proxy_set_header Host $host; proxy_cache_bypass $http_upgrade; } }' | sudo tee /etc/nginx/conf.d/app.conf",

      # Enable and start nginx service
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest-frontend.json"
  }
}