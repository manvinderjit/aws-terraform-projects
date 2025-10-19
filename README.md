# aws-terraform-projects

Repo showcasing multiple DevOps projects depoyed to AWS via Terraform and CI/CD pipelines through GitHub Actions.

# Project List

This repository contains multiple folders, each of which is a standalone deployment project with its own Terraform config and workflow file.

| Folder                                                                    | Description                                                                                                                                                                                  |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [1. Three Tier Infrastructure React Springboot RDS App](3-tier-infra-app) | Complete AWS three-tier infrastructure using Terraform, Packer, and GitHub Actions — deploying a **React frontend**, **Spring Boot backend**, and **MySQL database** via CI/CD.              |
| [2. EKS MSK RDS App](eks-msk-rds-app)                                     | Kubernetes-based three-tier application on AWS using **EKS**, **MSK (Kafka)**, and **RDS** — showcasing event-driven architecture with real-time data streaming and container orchestration. |

---

# Project Descriptions

## [1. Three Tier Infrastructure React Springboot RDS App](3-tier-infra-app/README.md)

### **Three-Tier Infrastructure App (Terraform + Packer + GitHub Actions)**

#### **Summary:**

This project automates the deployment of a full **three-tier web application** on AWS using **Terraform**, **Packer**, and **GitHub Actions**.

It provisions a **React-based frontend**, a **Java Spring Boot backend**, and a **MySQL (RDS)** database — all deployed through CI/CD pipelines.

![Architecture Diagram](3-tier-infra-app/AWS3TierApp.png)

**Description:**

- The infrastructure follows a secure, isolated VPC design with public, private, and database subnets.
- It builds custom EC2 AMIs for both the React frontend and the Spring Boot backend using Packer, and deploys them via Auto Scaling Groups behind an Application Load Balancer.
- A GitHub Actions workflow manages the full lifecycle — provisioning, AMI builds, application deployment, and teardown — providing a fully automated, reproducible infrastructure-as-code solution.

---

## [2. EKS MSK RDS App](eks-msk-rds-app/README.md)

### **Kubernetes Three-Tier Application (EKS + MSK + RDS)**

#### **Summary:**

This project demonstrates a complete **event-driven three-tier application** deployed on AWS using **Amazon EKS**, **MSK (Managed Kafka)**, and **RDS**.

It showcases modern cloud-native architecture with **real-time event streaming**, **container orchestration**, and **managed AWS services**.

**Application Source**: [react-springboot-kafka-apps](https://github.com/manvinderjit/react-springboot-kafka-apps)

**Description:**

- **EKS Cluster**: Managed Kubernetes with worker nodes in private subnets, complete with essential addons (VPC CNI, CoreDNS, Metrics Server)
- **Event Streaming**: MSK (Kafka) cluster for real-time message processing between React frontend and Spring Boot backend
- **Database**: MySQL RDS in isolated database subnets for persistent data storage
- **Application**: Event-driven React UI with Spring Boot API, featuring real-time analytics dashboard and live event processing
- **Infrastructure as Code**: Complete Terraform automation with GitHub Actions CI/CD pipeline
- **Container-Native**: Kubernetes manifests with ConfigMaps, Secrets, and health checks for production-ready deployment

**Key Features**: Real-time event streaming, Kubernetes-native scaling, managed AWS services integration, and comprehensive monitoring capabilities.

---
