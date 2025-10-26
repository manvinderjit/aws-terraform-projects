# S3 Static Website with CloudFront

A simple, cost-effective static website hosting solution using AWS S3 and CloudFront with automatic content deployment and secure access controls.

## Architecture

```
Internet → CloudFront (Default SSL) → Origin Access Control → S3 Bucket
                                                                    ↑
                                                          Terraform uploads content
```

## Features

### Core Infrastructure

- **S3 Bucket**: Static website hosting with automatic file upload
- **CloudFront**: Global CDN with default SSL certificate
- **Origin Access Control (OAC)**: Secure S3 access without public bucket policies
- **Automatic Content Deployment**: Terraform uploads website files with proper MIME types

### Security & Performance

- Secure S3 bucket (no public access)
- HTTPS by default using CloudFront's SSL certificate
- Optimized caching for static content
- Proper resource tagging for cost allocation

## Project Structure

```
s3-website/
├── main.tf                  # Root module orchestration
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── provider.tf              # Provider configuration
├── backend.tf               # Backend configuration
├── terraform.tfvars         # Environment configuration
├── modules/
│   ├── s3-website/          # S3 bucket and file upload
│   └── cloudfront/          # CloudFront distribution and OAC
├── website-content/         # Website files (HTML, CSS, JS)
└── README.md               # This file
```

## Deployment Options

### Option 1: GitHub Actions (Recommended)

This project includes automated CI/CD workflows for easy deployment and management.

#### Deploy via GitHub Actions

1. **Push to branch**: Push changes to `project/s3-website` branch
2. **Automatic deployment**: Workflow triggers automatically
3. **Monitor progress**: Check GitHub Actions tab for deployment status

#### Destroy via GitHub Actions

1. **Go to Actions tab** in your GitHub repository
2. **Select "Destroy S3 Website Infrastructure"** workflow
3. **Click "Run workflow"** and fill in:
   - **Confirm Destroy**: Type `DESTROY` exactly
   - **Bucket Name**: Enter your bucket name
4. **Monitor execution** and confirm completion

### Option 2: Local Terraform

#### Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0 installed

#### Deploy Infrastructure and Content

```bash
# Navigate to project directory
cd s3-website

# Initialize Terraform
terraform init

# Review planned changes
terraform plan

# Deploy infrastructure and upload content
terraform apply

# Get your website URL
terraform output website_url
```

#### Update Website Content

```bash
# After modifying files in website-content/
terraform apply
```

## Configuration

### terraform.tfvars

```hcl
# Core Configuration
aws_region  = "us-east-2"
bucket_name = "your-unique-bucket-name"

# Website Configuration
index_document = "index.html"
error_document = "error.html"

# CloudFront Configuration
cloudfront_comment = "My static website"

# Tags
tags = {
  ManagedBy   = "GitAwsTerraformProjects"
  Project     = "S3Website"
  Environment = "dev"
}
```

### Key Variables

| Variable             | Description              | Default      | Required |
| -------------------- | ------------------------ | ------------ | -------- |
| `bucket_name`        | Unique S3 bucket name    | -            | Yes      |
| `aws_region`         | AWS region for resources | `us-east-1`  | No       |
| `index_document`     | Main page file           | `index.html` | No       |
| `error_document`     | Error page file          | `error.html` | No       |
| `cloudfront_comment` | CloudFront description   | -            | No       |

## Requirements

- **Terraform**: >= 1.0
- **AWS Provider**: >= 5.0
- **AWS CLI**: Configured with appropriate permissions

## IAM Permissions Required

Your AWS role/user needs these permissions:

- `AmazonS3FullAccess` (or scoped S3 permissions)
- `CloudFrontFullAccess`
- Basic IAM permissions for policy documents

## Outputs

After successful deployment, you'll get:

| Output                       | Description                                           |
| ---------------------------- | ----------------------------------------------------- |
| `website_url`                | Your website URL (https://d1234567890.cloudfront.net) |
| `s3_bucket_id`               | S3 bucket name                                        |
| `cloudfront_distribution_id` | CloudFront distribution ID                            |
| `s3_direct_url`              | Direct S3 website URL (for testing)                   |

## Content Management

### Automatic Upload

Terraform automatically uploads all files from `website-content/` directory with:

- Proper MIME type detection
- File change detection (using ETags)
- Support for HTML, CSS, JS, images, and other static assets

### Manual Content Updates

```bash
# Option 1: Re-run Terraform (recommended)
terraform apply

# Option 2: Direct S3 sync (faster for large sites)
aws s3 sync ./website-content/ s3://$(terraform output -raw s3_bucket_id)/ --delete

# Option 3: Invalidate CloudFront cache after manual sync
aws cloudfront create-invalidation \
  --distribution-id $(terraform output -raw cloudfront_distribution_id) \
  --paths "/*"
```

## Security Features

- **Private S3 Bucket**: No public access, secured via CloudFront OAC
- **HTTPS by Default**: CloudFront provides SSL certificate automatically
- **Origin Access Control**: Modern replacement for Origin Access Identity
- **Resource Tagging**: Proper cost allocation and resource management

## Cost Optimization

- **CloudFront Price Class**: Uses `PriceClass_100` (cheapest option)
- **No Versioning**: Disabled for cost savings in development
- **Efficient Caching**: Static content cached at edge locations
- **No Logging**: Disabled to reduce costs (can be enabled if needed)

## Troubleshooting

### Common Issues

1. **403 Forbidden Errors**

   - Check if S3 bucket policy allows CloudFront access
   - Verify Origin Access Control is properly configured

2. **Content Not Updating**

   - Run `terraform apply` to upload new content
   - CloudFront cache may take 5-10 minutes to update

3. **Bucket Name Already Exists**
   - S3 bucket names must be globally unique
   - Change `bucket_name` in `terraform.tfvars`

### Useful Commands

```bash
# Check deployment status
terraform output

# View CloudFront distribution details
aws cloudfront get-distribution --id $(terraform output -raw cloudfront_distribution_id)

# List uploaded files
aws s3 ls s3://$(terraform output -raw s3_bucket_id)/ --recursive
```

## Infrastructure Management

### GitHub Actions Workflows

This project includes two GitHub Actions workflows:

#### 1. **Deploy Workflow** (`s3-website.yaml`)

- **Trigger**: Automatic on push to `project/s3-website` branch
- **Purpose**: Deploy infrastructure and upload website content
- **Features**:
  - Terraform format checking
  - Infrastructure validation
  - Automatic deployment
  - Uses OIDC for secure AWS access

#### 2. **Destroy Workflow** (`s3-website-destroy.yaml`)

- **Trigger**: Manual only (workflow_dispatch)
- **Purpose**: Safely destroy all infrastructure
- **Safety Features**:
  - Requires typing "DESTROY" to confirm
  - Shows destroy plan before execution
  - Automatically empties S3 bucket
  - Detailed logging and confirmation

### Local Cleanup

To destroy all resources locally:

```bash
terraform destroy
```

**⚠️ Warning**: This will permanently delete your S3 bucket and all website content.

## GitHub Actions Setup

### Required Secrets

Configure these secrets in your GitHub repository settings:

| Secret                        | Description                      | Example                                            |
| ----------------------------- | -------------------------------- | -------------------------------------------------- |
| `AWS_REGION`                  | AWS region for deployment        | `us-east-2`                                        |
| `AWS_TERRAFORM_GITHUB_ROLE`   | OIDC role ARN for GitHub Actions | `arn:aws:iam::123456789012:role/GitHubActionsRole` |
| `AWS_TFSTATE_BUCKET_NAME`     | S3 bucket for Terraform state    | `your-terraform-state-bucket`                      |
| `AWS_TFSTATE_BUCKET_KEY_NAME` | State file name                  | `terraform.tfstate`                                |

### Workflow Triggers

- **Deploy**: Automatically triggers on push to `project/s3-website` branch
- **Destroy**: Manual trigger only from GitHub Actions UI

## Next Steps

- Add custom domain with Route 53 and ACM certificate
- Enable CloudFront access logging
- Add WAF for additional security
- Set up branch protection rules for production deployments
