# Three-Tier Infrastructure App with Docker & ECR

This project demonstrates a complete three-tier web application deployed on AWS EKS using Docker containers stored in Amazon ECR (Elastic Container Registry).

## Architecture Overview

- **Frontend**: React application (Port 8081)
- **Backend**: Java Spring Boot application (Port 8080)
- **Database**: Amazon RDS MySQL
- **Message Queue**: Amazon MSK (Managed Streaming for Apache Kafka)
- **Container Registry**: Amazon ECR
- **Orchestration**: Amazon EKS

> **Source Code**: The application source code and Docker build files are available at: https://github.com/manvinderjit/react-springboot-kafka-apps

## Project Structure

```
three-tier-infra-app-docker-ecr/
├── docker-files/              # Docker build files
├── helm-chart/               # Helm chart templates (optional)
├── k8-manifests/            # Kubernetes manifests
│   ├── backend/
│   │   ├── configmap.yaml          # Backend configuration
│   │   ├── secrets.yaml            # Backend secrets
│   │   ├── 1-deployment-backend.yaml
│   │   └── 2-svc-cluster-backend.yaml
│   └── frontend/
│       ├── configmap.yaml          # Frontend configuration
│       ├── 1-deployment-frontend.yaml
│       └── 2-2-svc-cluster-frontend.yaml
├── main.tf                  # Terraform infrastructure
├── provider.tf              # Terraform provider configuration
├── variables.tf             # Terraform variables
└── README.md               # This file
```

## Prerequisites

- AWS CLI configured with appropriate permissions
- kubectl configured to connect to your EKS cluster
- Docker images pushed to ECR:
  - `manvinderjit/kafka-project-backend:v2`
  - `manvinderjit/kafka-project-frontend:v2`
  - **Note**: These images are generated from the source code available at: https://github.com/manvinderjit/react-springboot-kafka-apps
- Running AWS infrastructure:
  - EKS cluster
  - RDS MySQL instance
  - MSK Kafka cluster

## Configuration

### Environment Variables

Before deploying, update the placeholder values in the ConfigMaps:

**Backend ConfigMap** (`k8-manifests/backend/configmap.yaml`):

- `YOUR_KAFKA_BOOTSTRAP_SERVERS` - MSK Kafka bootstrap servers
- `YOUR_RDS_ENDPOINT` - RDS MySQL endpoint
- `YOUR_DATABASE_NAME` - Database name
- `YOUR_DB_USERNAME` - Database username

**Backend Secret** (`k8-manifests/backend/secrets.yaml`):

- `YOUR_DB_PASSWORD` - Database password (base64 encoded)

**Frontend ConfigMap** (`k8-manifests/frontend/configmap.yaml`):

- `YOUR_KAFKA_BOOTSTRAP_SERVERS` - MSK Kafka bootstrap servers

## Deployment Instructions

### 1. Update Configuration Values

Edit the ConfigMap files with your actual AWS resource endpoints:

```bash
# Edit backend configuration
vi k8-manifests/backend/configmap.yaml
vi k8-manifests/backend/secrets.yaml

# Edit frontend configuration
vi k8-manifests/frontend/configmap.yaml
```

### 2. Deploy to Kubernetes

Apply the manifests in the following order:

```bash
# Apply ConfigMaps and Secrets first
kubectl apply -f k8-manifests/backend/configmap.yaml
kubectl apply -f k8-manifests/backend/secrets.yaml
kubectl apply -f k8-manifests/frontend/configmap.yaml

# Apply Deployments
kubectl apply -f k8-manifests/backend/1-deployment-backend.yaml
kubectl apply -f k8-manifests/frontend/1-deployment-frontend.yaml

# Apply Services
kubectl apply -f k8-manifests/backend/2-svc-cluster-backend.yaml
kubectl apply -f k8-manifests/frontend/2-2-svc-cluster-frontend.yaml
```

### 3. Alternative: Apply All at Once

```bash
# Apply all manifests recursively
kubectl apply -f k8-manifests/ --recursive
```

## Verification

### Check Deployment Status

```bash
# Check all resources
kubectl get all

# Check ConfigMaps
kubectl get configmaps
kubectl describe configmap backend-config
kubectl describe configmap frontend-config

# Check Secrets
kubectl get secrets
kubectl describe secret backend-secrets

# Check Pods
kubectl get pods
kubectl logs -f deployment/deployment-kafka-project-backend
kubectl logs -f deployment/deployment-kafka-project-frontend
```

### Test Application

```bash
# Port forward to test locally
kubectl port-forward service/service-kafka-project-frontend 8081:8081
kubectl port-forward service/service-kafka-project-backend 8080:8080

# Access the application
curl http://localhost:8081
curl http://localhost:8080/api/events
```

## Scaling

```bash
# Scale backend replicas
kubectl scale deployment deployment-kafka-project-backend --replicas=4

# Scale frontend replicas
kubectl scale deployment deployment-kafka-project-frontend --replicas=3
```

## Updates

### Update Configuration

```bash
# Edit ConfigMap
kubectl edit configmap backend-config

# Restart deployment to pick up changes
kubectl rollout restart deployment/deployment-kafka-project-backend
kubectl rollout restart deployment/deployment-kafka-project-frontend
```

### Update Application Images

```bash
# Update image version
kubectl set image deployment/deployment-kafka-project-backend kafka-project-backend=manvinderjit/kafka-project-backend:v3
kubectl set image deployment/deployment-kafka-project-frontend kafka-project-frontend=manvinderjit/kafka-project-frontend:v3
```

## Cleanup

```bash
# Delete all resources
kubectl delete -f k8-manifests/ --recursive

# Or delete individual components
kubectl delete -f k8-manifests/backend/
kubectl delete -f k8-manifests/frontend/
```

## Troubleshooting

### Common Issues

1. **Pods not starting**: Check ConfigMap values and ensure AWS resources are accessible
2. **Connection errors**: Verify security groups and network connectivity
3. **Image pull errors**: Ensure ECR permissions and image tags are correct

### Debug Commands

```bash
# Check pod logs
kubectl logs -f <pod-name>

# Describe pod for events
kubectl describe pod <pod-name>

# Check service endpoints
kubectl get endpoints

# Test connectivity from within cluster
kubectl run debug --image=busybox -it --rm -- sh
```

## Security Notes

- Secrets are base64 encoded, not encrypted
- For production, consider using AWS Secrets Manager with External Secrets Operator
- Ensure proper RBAC and network policies are in place
- Regularly update container images for security patches

## Contributing

1. Update placeholder values with your actual AWS resource endpoints
2. Test deployments in a development environment first
3. Follow Kubernetes best practices for resource limits and health checks
4. Document any configuration changes
