# 🏗️ Three-Tier Infrastructure App on AWS (Terraform + Packer + GitHub Actions)

This project demonstrates an end-to-end deployment of a three-tier web application architecture on AWS using **Terraform**, **Packer**, and **GitHub Actions** for CI/CD.

---

## 📦 Architecture Overview

![Architecture Diagram](AWS3TierApp.png)

The stack includes:

- **Frontend (Web UI)** hosted on EC2, served via ALB (port 80)
- **Backend (Spring Boot API)** hosted on EC2 (port 8080)
- **MySQL Database (RDS)** in private subnets

**Fully isolated VPC layout**:

- Public subnets (frontend, NAT)
- Private subnets (backend)
- RDS subnets (for DB-only access)

### Load Balancer Behavior:

- `/` → Frontend React App (port 3000, served via ALB on port 80)
- `/api/*` → Backend Spring Boot API (via ALB port 8080)

---

## 🧱 Technologies Used

| Tool           | Purpose                                    |
|----------------|--------------------------------------------|
| Terraform      | Infrastructure as Code                     |
| Packer         | Golden AMI creation for EC2 instances      |
| GitHub Actions | CI/CD pipeline to deploy everything        |
| AWS            | Cloud provider for compute/networking      |

---

## 🗺️ Project Structure

### Project Structure

```bash
3-tier-infra-app/
│
├── base-infra-rds/ # VPC, subnets, IGW, NAT, ALBs, RDS
├── backend/ # Backend EC2 ASG, launch templates
├── frontend/ # Frontend EC2 ASG, launch templates
├── app.pkr.hcl # Packer for backend EC2 AMI
├── web.pkr.hcl # Packer for frontend EC2 AMI
├── .github/workflows/ # GitHub Actions CI/CD pipelines
└── README.md # Project documentation
```
---

## 🚀 Infrastructure Overview

### VPC & Subnets

- **Custom VPC CIDR**: `192.168.0.0/16`
- **6 subnets total**:
  - 2 Public (ALB, NAT)
  - 2 Private (Backend EC2)
  - 2 RDS-only (Private DB access)

### Route Tables


| Route Type | Internet Access     | Usage                     |
|------------|---------------------|---------------------------|
| Public     | IGW (Internet GW)   | ALB, NAT, frontend EC2    |
| Private    | NAT Gateway         | Backend EC2               |
| DB-only    | ❌ No internet       | RDS subnets               |

### Security Groups

| SG Name            | Purpose                              |
|--------------------|--------------------------------------|
| `fe-alb-sg`        | Allow HTTP from public               |
| `webserver-ec2-sg` | Allow SSH & HTTP from ALB            |
| `private-ec2-sg`   | Allow HTTP from ALB and SSH from public EC2 |
| `rds-sg`           | Allow MySQL from backend EC2         |

### RDS

- **Engine**: MySQL 8.0
- **Instance**: `db.t4g.micro`
- **Placement**: Private subnets
- **Public access**: ❌ No public access

## 🧱 Terraform Highlights

### 🔁 Remote State (Shared Infrastructure)

Both frontend and backend consume outputs from the shared `base-infra-rds` module using:

```hcl
data "terraform_remote_state" "base_infra" {
  backend = "s3"
  config = {
    bucket = var.tfstate_bucket
    key    = var.base_tfstate_key
    region = var.tfstate_region
  }
}
```

---

## 🛠️ Build & Deployment Process (CI/CD)

### 🔄 Trigger

- Triggered on **push** to `project/3-tier-infra-app` branch
- Or manually via GitHub Actions (`workflow_dispatch`)

### 🧬 Steps

1. Provision VPC + RDS via Terraform
2. Fetch RDS endpoint
3. Build Backend AMI via Packer
4. Provision Backend EC2 (private subnet)
5. Build Frontend AMI via Packer (optional)
6. Provision Frontend EC2 (public subnet)

### 🧹 Teardown

- Use the GitHub Actions workflow manually with `destroy` input to tear down everything (frontend, backend, base infra).

---

## ✅ Requirements

### Local Setup

Make sure you have the following installed:

- [Terraform](https://www.terraform.io/)
- [Packer](https://www.packer.io/)
- AWS credentials configured (`~/.aws/credentials` or environment variables)
- SSH key pair in AWS (`aws-labs-becloudready` by default)

Secrets like RDS username/password are passed via GitHub Secrets or `terraform.tfvars`.

---

## 🔐 GitHub Secrets Required

| Secret Name                         | Description                              |
|-------------------------------------|------------------------------------------|
| `AWS_REGION`                        | AWS region (e.g., `us-east-2`)           |
| `AWS_TERRAFORM_GITHUB_ROLE`        | IAM Role ARN for GitHub OIDC             |
| `AWS_TFSTATE_BUCKET_NAME`          | S3 Bucket for remote state               |
| `AWS_TFSTATE_BUCKET_KEY_NAME`      | Key name for the tfstate                 |
| `AWS_TFSTATE_REGION`               | Region for state bucket                  |
| `AWS_TFSTATE_LOCK_TABLE_NAME`      | DynamoDB lock table                      |
| `AWS_THREE_TIER_RDS_DB_NAME`       | Name of the RDS DB                       |
| `AWS_THREE_TIER_RDS_DB_USER_NAME`  | RDS master username                      |
| `AWS_THREE_TIER_RDS_DB_PASSWORD`   | RDS master password                      |



## 🌐 Load Balancer Routing

- `http://<alb-dns-name>/` → Frontend (port 3000)
- `http://<alb-dns-name>/api/*` → Backend (port 8080)

---

## 🧪 Health Checks

- **Frontend Target Group**: `/` on port 3000
- **Backend Target Group**: `/api/movies` on port 8080

---

## 📤 Terraform Outputs

| Output Name                  | Description                          |
|------------------------------|--------------------------------------|
| `rds_endpoint`               | MySQL DB endpoint                    |
| `vpc_id`                     | VPC ID                               |
| `public_subnet_ids`         | List of public subnet IDs            |
| `private_subnet_ids`        | List of private subnet IDs           |
| `rds_subnet_ids`            | RDS subnet IDs                       |
| `frontend_alb_arn`          | ARN of the frontend ALB              |
| `frontend_target_group_arn` | ALB Target Group for frontend        |
| `backend_target_group_arn`  | ALB Target Group for backend         |

---

## 🧼 Cleanup

Trigger the **destroy** workflow from GitHub Actions tab to clean up the entire infrastructure.

---

## 📄 License

**MIT License** – use this project for learning, testing, or bootstrapping your own!
