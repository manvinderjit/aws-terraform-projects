# packer {
#   required_plugins {
#     amazon = {
#       version = ">= 1.2.8"
#       source  = "github.com/hashicorp/amazon"
#     }
#   }
# }

# variable "aws_region" {
#   type    = string
#   default = "us-east-2"
# }

variable "ami_name_web" {
  type    = string
  default = "three-tier-ami-web"
}

variable "backend_alb_dns" {
  type = string
}

source "amazon-ebs" "web" {
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
  ami_name = "${var.ami_name_web}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
}

build {
  sources = ["source.amazon-ebs.web"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git nodejs npm nginx",
      "cd /home/ec2-user",
      "sudo mkdir tmpf tmpf/web",
      "sudo git clone https://github.com/manvinderjit/react-springboot-test-app.git tmpf/web",
      "sudo mkdir -p web",
      "sudo cp -r tmpf/web/frontend/. web/",
      "cd web",
      "sudo npm install",
      "sudo VITE_API_BASE_URL=\"http://${var.backend_alb_dns}\" npm run build",
      "sudo npm install -g serve",
      
      # Create nginx config
      "echo 'server { listen 80; location / { proxy_pass http://localhost:3000; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection \"upgrade\"; proxy_set_header Host $host; proxy_cache_bypass $http_upgrade; } }' | sudo tee /etc/nginx/conf.d/app.conf",

      # Enable and start nginx service
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo rm -rf /home/ec2-user/tmpf"
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest.json"
  }
}