# 🖥️ EC2 AMI EC2 - Custom AMI Creation and Deployment

This project demonstrates **AWS AMI (Amazon Machine Image) creation and replication** using Terraform. It showcases the process of creating a custom AMI from a running EC2 instance and using that AMI to deploy identical instances.

---

## 📦 Architecture Overview

![Architecture](https://img.shields.io/badge/Architecture-EC2%20%2B%20AMI%20Creation-orange)

The project workflow:

1. **Source EC2 Instance** - Deploy initial EC2 with custom configuration
2. **AMI Creation** - Create custom AMI from the running instance
3. **AMI Deployment** - Launch new EC2 instances using the custom AMI
4. **IAM Integration** - EC2 instances with S3 read-only access

### Key Components:
- **EC2 Instances**: t2.micro instances with public IP addresses
- **Custom AMI**: Created from configured EC2 instance
- **Security Group**: HTTP (80) and SSH (22) access
- **IAM Role**: S3 read-only permissions for EC2 instances
- **User Data**: Custom initialization script

---

## 🧱 Technologies Used

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Infrastructure** | Terraform | Infrastructure as Code |
| **Compute** | Amazon EC2 | Virtual server instances |
| **Images** | Amazon AMI | Custom machine images |
| **Security** | IAM Roles | EC2 service permissions |
| **Networking** | Security Groups | Network access control |
| **Storage** | Amazon S3 | Object storage access |

---

## 🗺️ Project Structure

```bash
ec2-ami-ec2/
│
├── main.tf                   # Main Terraform configuration
├── provider.tf              # AWS provider and backend config
├── variables.tf             # Input variables
└── README.md                # This file
```

---

## 🏗️ Infrastructure Components

### EC2 Instances
- **Instance Type**: t2.micro (Free Tier eligible)
- **AMI**: Amazon Linux 2023
- **Network**: Public IP addresses enabled
- **Key Pair**: SSH access via EC2 key pair

### Security Group
- **Inbound Rules**:
  - SSH (22): Access from anywhere (0.0.0.0/0)
  - HTTP (80): Web access from anywhere
- **Outbound Rules**: All traffic allowed

### IAM Configuration
- **Role**: EC2 service role with S3 read-only access
- **Policy**: AmazonS3ReadOnlyAccess
- **Instance Profile**: Attached to EC2 instances

### Custom AMI
- **Source**: First EC2 instance with custom configuration
- **Content**: Includes user data script and custom files
- **Lifecycle**: Create before destroy for zero-downtime updates

---

## 🚀 Deployment Guide

### Prerequisites

1. **AWS CLI** configured with appropriate permissions
2. **Terraform** installed (v1.0+)
3. **EC2 Key Pair** created in AWS (us-east-2 region)

### Step 1: Configure Variables

Create a `terraform.tfvars` file:
```hcl
ec2_key_name = "your-ec2-key-pair-name"
```

### Step 2: Deploy Infrastructure

```bash
cd ec2-ami-ec2

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="terraform.tfvars"

# Apply configuration
terraform apply -var-file="terraform.tfvars"
```

### Step 3: Verify Deployment

```bash
# List EC2 instances
aws ec2 describe-instances --region us-east-2 \
  --filters "Name=tag:Project,Values=ec2-ami-ec2" \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`]|[0].Value,InstanceId:InstanceId,State:State.Name,PublicIP:PublicIpAddress}'

# List custom AMIs
aws ec2 describe-images --region us-east-2 \
  --owners self \
  --filters "Name=name,Values=ec2-ami-ec2-web-server-ami*"
```

### Step 4: Test Instances

```bash
# SSH to original instance
ssh -i your-key.pem ec2-user@<ORIGINAL_INSTANCE_IP>
cat /home/ec2-user/creation-info.txt

# SSH to cloned instance
ssh -i your-key.pem ec2-user@<CLONED_INSTANCE_IP>
cat /home/ec2-user/creation-info.txt
```

---

## 🔧 Configuration Details

### User Data Script
The original EC2 instance runs a user data script that:
```bash
#!/bin/bash
echo "I was created in the first ec2 instance." > /home/ec2-user/creation-info.txt
chown ec2-user:ec2-user /home/ec2-user/creation-info.txt
```

### AMI Creation Process
1. **Source Instance**: EC2 instance with custom configuration
2. **AMI Snapshot**: Terraform creates AMI from running instance
3. **Image Replication**: New instances launched from custom AMI
4. **Verification**: Both instances contain identical configuration

---

## 🧪 Testing & Validation

### Verify AMI Creation
```bash
# Check AMI status
aws ec2 describe-images --region us-east-2 \
  --image-ids $(terraform output -raw custom_ami_id)

# Verify instance configuration
aws ec2 describe-instances --region us-east-2 \
  --instance-ids $(terraform output -raw original_instance_id) \
  --query 'Reservations[].Instances[].{ImageId:ImageId,InstanceType:InstanceType}'
```

### Test S3 Access
```bash
# SSH to instance and test S3 access
ssh -i your-key.pem ec2-user@<INSTANCE_IP>
aws s3 ls  # Should list S3 buckets (read-only access)
```

---

## 🔄 AMI Management

### Update AMI
To create a new version of the AMI:
1. Modify the source EC2 instance
2. Run `terraform apply` to create new AMI
3. Terraform will create new AMI before destroying old one

### AMI Cleanup
```bash
# List all custom AMIs
aws ec2 describe-images --owners self --region us-east-2

# Deregister old AMI (if needed)
aws ec2 deregister-image --image-id ami-xxxxxxxxx --region us-east-2
```

---

## 🧹 Cleanup

### Destroy Infrastructure
```bash
# Destroy all resources
terraform destroy -var-file="terraform.tfvars"

# Note: Custom AMIs may need manual cleanup
aws ec2 describe-images --owners self --region us-east-2
aws ec2 deregister-image --image-id <AMI_ID> --region us-east-2
```

---

## 🎯 Use Cases

This project demonstrates:

- ✅ **Golden AMI Creation**: Build standardized server images
- ✅ **Infrastructure Scaling**: Rapid deployment of identical instances
- ✅ **Configuration Management**: Consistent server configurations
- ✅ **Disaster Recovery**: Quick instance replacement using custom AMIs
- ✅ **Development Workflows**: Environment replication and testing

---

## 🔐 Security Considerations

- **Key Management**: Secure EC2 key pair storage
- **IAM Permissions**: Least privilege access (S3 read-only)
- **Security Groups**: Restrict SSH access to specific IP ranges in production
- **AMI Sharing**: Control AMI visibility and sharing permissions

---

## 📚 Additional Resources

- [Amazon EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [AMI Best Practices](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)

---

## 📄 License

**MIT License** – Use this project for learning, testing, or as a foundation for your AMI management workflows.