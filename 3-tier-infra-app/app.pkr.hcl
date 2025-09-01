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
      "sudo yum install -y git wget unzip",
      "sudo yum install -y java-21-amazon-corretto-devel",
      "wget https://downloads.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.zip -P /tmp",
      "sudo unzip /tmp/apache-maven-3.9.4-bin.zip -d /opt",
      "sudo ln -s /opt/apache-maven-3.9.4 /opt/maven",
      "echo 'export MAVEN_HOME=/opt/maven' | sudo tee /etc/profile.d/maven.sh",
      "echo 'export PATH=$MAVEN_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/maven.sh",
      "sudo chmod +x /etc/profile.d/maven.sh",
      
      "git clone https://github.com/manvinderjit/react-springboot-test-app.git /tmp/app",
      "mkdir -p /app",
      "cp -r /tmp/app/backend/* /app/",
      
      # Run mvn build in a single bash session with Maven env loaded
      "bash -c 'source /etc/profile.d/maven.sh && cd /app && mvn clean package -DskipTests'",
      
      "rm -rf /tmp/apache-maven-3.9.4-bin.zip /tmp/app",

      # The jar file will be in /app/target/*.jar               
    ]
  }

  post-processor "manifest" {
    output = "packer-manifest.json"
  }
}