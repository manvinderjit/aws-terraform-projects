# Kubernetes Manifests

This directory contains Kubernetes manifests for deploying the three-tier application (frontend + backend) to the EKS cluster.

## Environment Variable Substitution

The manifests use environment variable substitution to inject values from Terraform outputs and GitHub secrets:

### Backend Configuration (`backend/configmap.yaml`)

- `${MSK_BOOTSTRAP_BROKERS}` - Kafka bootstrap servers from Terraform output
- `${RDS_ENDPOINT}` - RDS endpoint from Terraform output
- `${RDS_PORT}` - RDS port from Terraform output
- `${DB_NAME}` - Database name from GitHub secret
- `${DB_USERNAME}` - Database username from GitHub secret

### Backend Secrets (`backend/secrets.yaml`)

- `${DB_PASSWORD_BASE64}` - Base64 encoded database password from GitHub secret

### Frontend Configuration (`frontend/configmap.yaml`)

- `${MSK_BOOTSTRAP_BROKERS}` - Kafka bootstrap servers from Terraform output

## Deployment

The manifests are automatically deployed by the GitHub Actions workflow after Terraform infrastructure provisioning:

1. **Infrastructure Deployment**: Terraform creates EKS, RDS, MSK, and ALB
2. **Get Outputs**: Workflow extracts Terraform outputs (endpoints, ports, etc.)
3. **Environment Substitution**: `envsubst` replaces variables in manifests
4. **Kubernetes Deployment**: `kubectl apply` deploys the processed manifests
5. **Health Checks**: Workflow waits for deployments to be ready

## Workflows

- **Deploy Workflow** (`.github/workflows/eks-msk-rds-app.yaml`): Deploys infrastructure and applications
- **Destroy Workflow** (`.github/workflows/eks-msk-rds-app-destroy.yaml`): Cleans Kubernetes apps then destroys infrastructure

## Manual Deployment

If you need to deploy manually:

```bash
# Set environment variables
export MSK_BOOTSTRAP_BROKERS="your-kafka-brokers"
export RDS_ENDPOINT="your-rds-endpoint"
export RDS_PORT="3306"
export DB_NAME="your-db-name"
export DB_USERNAME="your-db-username"
export DB_PASSWORD="your-db-password"
export DB_PASSWORD_BASE64=$(echo -n "$DB_PASSWORD" | base64 -w 0)

# Deploy with environment substitution
envsubst < backend/configmap.yaml | kubectl apply -f -
DB_PASSWORD_BASE64=$DB_PASSWORD_BASE64 envsubst < backend/secrets.yaml | kubectl apply -f -
envsubst < frontend/configmap.yaml | kubectl apply -f -

# Deploy applications
kubectl apply -f backend/1-deployment-backend.yaml
kubectl apply -f backend/2-svc-cluster-backend.yaml
kubectl apply -f frontend/1-deployment-frontend.yaml
kubectl apply -f frontend/2-2-svc-cluster-frontend.yaml
```

## Application Access

After deployment, the application is accessible via the ALB DNS name (available in Terraform outputs).
