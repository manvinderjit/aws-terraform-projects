# 🌐 Subnet EC2 RDS - VPC Networking Fundamentals

This project demonstrates **AWS VPC networking fundamentals** with EC2 and RDS integration using Terraform. It showcases essential networking concepts including subnets, route tables, security groups, and database connectivity patterns.

---

## 📦 Architecture Overview

![Architecture](https://img.shields.io/badge/Architecture-VPC%20%2B%20EC2%20%2B%20RDS-green)

The project demonstrates:

1. **Custom VPC** - Isolated network environment with DNS support
2. **Multi-Subnet Design** - Public and private subnets across availability zones
3. **EC2 Web Server** - Public instance with HTTP server
4. **RDS Database** - PostgreSQL database in private subnets
5. **Security Groups** - Network-level security controls

### Network Architecture:
- **Public Subnet**: Web server with internet access
- **Private Subnets**: Database instances (isolated from internet)
- **Security Groups**: Controlled access between tiers

---

## 🧱 Technologies Used

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Infrastructure** | Terraform | Infrastructure as Code |
| **Networking** | Amazon VPC | Virtual private cloud |
| **Compute** | Amazon EC2 | Web server instance |
| **Database** | Amazon RDS (PostgreSQL) | Managed database service |
| **Security** | Security Groups | Network access control |
| **Routing** | Route Tables | Network traffic routing |

---

## 🗺️ Project Structure

```bash
subnet-ec2-rds/
│
├── main.tf                   # Main Terraform configuration
├── provider.tf              # AWS provider and backend config
├── variables.tf             # Input variables
└── README.md                # This file
```

---

## 🏗️ Infrastructure Components

### VPC Configuration
- **CIDR Block**: `10.0.0.0/16`
- **DNS Support**: Enabled for hostname resolution
- **DNS Hostnames**: Enabled for public DNS names

### Subnet Design
- **Public Subnet**: `10.0.1.0/24` (us-east-2a)
  - Internet access via Internet Gateway
  - Auto-assign public IP addresses
- **Private Subnet A**: `10.0.2.0/24` (us-east-2a)
  - No internet access
  - Database subnet group member
- **Private Subnet B**: `10.0.3.0/24` (us-east-2b)
  - No internet access
  - Database subnet group member (Multi-AZ support)

### EC2 Web Server
- **Instance Type**: t2.micro (Free Tier eligible)
- **AMI**: Amazon Linux 2023 (latest)
- **Location**: Public subnet with public IP
- **Web Server**: Apache HTTP server with custom page

### RDS Database
- **Engine**: PostgreSQL 17.4
- **Instance Class**: db.t4g.micro
- **Storage**: 20GB GP2
- **Multi-AZ**: Disabled (cost optimization)
- **Backup**: Disabled (development setup)
- **Public Access**: Disabled (security best practice)

### Security Groups
- **EC2 Security Group**:
  - Inbound: HTTP (80) from anywhere
  - Outbound: All traffic allowed
- **RDS Security Group**:
  - Inbound: PostgreSQL (5432) from EC2 security group only
  - Outbound: All traffic allowed

---

## 🚀 Deployment Guide

### Prerequisites

1. **AWS CLI** configured with appropriate permissions
2. **Terraform** installed (v1.0+)
3. **Database credentials** for RDS setup

### Step 1: Configure Variables

Create a `terraform.tfvars` file:
```hcl
aws_region    = "us-east-2"
db_username   = "your_db_username"
db_password   = "your_secure_password"
```

### Step 2: Deploy Infrastructure

```bash
cd subnet-ec2-rds

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="terraform.tfvars"

# Apply configuration
terraform apply -var-file="terraform.tfvars"
```

### Step 3: Verify Deployment

```bash
# Get EC2 public IP
aws ec2 describe-instances --region us-east-2 \
  --filters "Name=tag:Name,Values=web-instance-subnet-ec2-rds" \
  --query 'Reservations[].Instances[].PublicIpAddress' --output text

# Get RDS endpoint
aws rds describe-db-instances --region us-east-2 \
  --db-instance-identifier terraform-db \
  --query 'DBInstances[0].Endpoint.Address' --output text
```

### Step 4: Test Web Server

```bash
# Test HTTP server (replace with actual public IP)
curl http://<EC2_PUBLIC_IP>

# Should return: <h1>Hello from Terraform EC2!</h1>
```

---

## 🔧 Network Configuration Details

### Route Tables
- **Public Route Table**:
  - `0.0.0.0/0` → Internet Gateway (internet access)
  - Associated with public subnet
- **Private Subnets**:
  - Use default VPC route table (local traffic only)
  - No internet gateway route (isolated)

### Security Group Rules
```hcl
# EC2 Security Group
ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
}

# RDS Security Group
ingress {
  from_port       = 5432
  to_port         = 5432
  protocol        = "tcp"
  security_groups = [aws_security_group.ec2_sg.id]  # Only from EC2
}
```

### Database Connectivity
- **DB Subnet Group**: Spans multiple AZs for high availability
- **Network Isolation**: Database accessible only from EC2 instances
- **Security**: No public internet access to database

---

## 🧪 Testing & Validation

### Network Connectivity Tests
```bash
# SSH to EC2 instance (requires key pair)
ssh -i your-key.pem ec2-user@<EC2_PUBLIC_IP>

# Test database connectivity from EC2
sudo yum install -y postgresql15
psql -h <RDS_ENDPOINT> -U <DB_USERNAME> -d postgres

# Test web server locally
curl localhost
```

### Infrastructure Verification
```bash
# Verify VPC configuration
aws ec2 describe-vpcs --region us-east-2 \
  --filters "Name=tag:Name,Values=vpc-subnet-ec2-rds"

# Check subnet configuration
aws ec2 describe-subnets --region us-east-2 \
  --filters "Name=vpc-id,Values=<VPC_ID>"

# Verify security groups
aws ec2 describe-security-groups --region us-east-2 \
  --filters "Name=group-name,Values=ec2-sg-subnet-ec2-rds"
```

---

## 🔄 Common Operations

### Database Management
```bash
# Connect to database
psql -h <RDS_ENDPOINT> -U <DB_USERNAME> -d postgres

# Create sample database
CREATE DATABASE sample_app;

# List databases
\l
```

### Web Server Management
```bash
# SSH to EC2 and manage Apache
sudo systemctl status httpd
sudo systemctl restart httpd

# Update web content
echo "<h1>Updated content</h1>" | sudo tee /var/www/html/index.html
```

---

## 🧹 Cleanup

### Destroy Infrastructure
```bash
# Destroy all resources
terraform destroy -var-file="terraform.tfvars"

# Confirm destruction
aws ec2 describe-instances --region us-east-2 \
  --filters "Name=tag:Project,Values=subnet-ec2-rds"
```

---

## 🎯 Learning Objectives

This project teaches:

- ✅ **VPC Fundamentals**: Creating isolated network environments
- ✅ **Subnet Design**: Public vs private subnet patterns
- ✅ **Security Groups**: Network-level access controls
- ✅ **Route Tables**: Traffic routing and internet access
- ✅ **Multi-AZ Design**: Database high availability patterns
- ✅ **EC2-RDS Integration**: Secure database connectivity
- ✅ **Infrastructure as Code**: Terraform networking resources

---

## 🔐 Security Best Practices

- **Database Isolation**: RDS in private subnets with no public access
- **Security Group Rules**: Least privilege access (database only from EC2)
- **Network Segmentation**: Separate subnets for different tiers
- **Credential Management**: Sensitive variables marked as sensitive
- **Multi-AZ Support**: Database subnet group spans availability zones

---

## 🚀 Extension Ideas

- Add NAT Gateway for private subnet internet access
- Implement Application Load Balancer for web tier
- Add Auto Scaling Group for EC2 instances
- Configure VPC Flow Logs for network monitoring
- Implement database encryption and backup strategies

---

## 📚 Additional Resources

- [Amazon VPC User Guide](https://docs.aws.amazon.com/vpc/)
- [VPC Security Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [RDS Security Groups](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.RDSSecurityGroups.html)
- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)

---

## 📄 License

**MIT License** – Use this project for learning, testing, or as a foundation for your VPC networking implementations.