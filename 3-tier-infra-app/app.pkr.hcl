source "amazon-ebs" "app" {
  region                  = var.aws_region
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*-x86_64"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["137112412989"] # Amazon as official owner
    most_recent = true
  }

  instance_type          = "t2.nano"
  ssh_username           = "ec2-user"
  ami_name               = "${var.ami_name}-${timestamp()}"
}

build {
  sources = ["source.amazon-ebs.app"]

  provisioner "shell" {
    inline = [
      "dnf update -y",
      "dnf install -y git nodejs npm",
      "cd /home/ec2-user",
      "git clone https://github.com/manvinderjit/2023-TOP-Project-Shopping-Cart.git app",
      "cd app",
      "npm install",
      "VITE_API_BASE_URL=\"https://ia.manvinderjit.com/\" npm run build",
      "npm install -g serve",
      "serve -s dist &"
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest.json"
  }
}