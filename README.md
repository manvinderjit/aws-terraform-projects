# aws-terraform-projects
Repo showcasing multiple DevOps projects depoyed to AWS via Terraform and CI/CD pipelines through GitHub Actions.

# Project List

This repository contains multiple folders, each of which is a standalone deployment project with its own Terraform config and workflow file.


| Folder | Description |
|--------|--------------|
| [1. Three Tier Infrastructure React Springboot RDS App](3-tier-infra-app) | Complete AWS three-tier infrastructure using Terraform, Packer, and GitHub Actions — deploying a **React frontend**, **Spring Boot backend**, and **MySQL database** via CI/CD. |
| [2. Three Tier Infrastructure App with Docker & ECR](three-tier-infra-app-docker-ecr) | Containerized three-tier application deployed on **AWS EKS** using **Docker containers** stored in **Amazon ECR**, with **Kafka messaging** and **RDS MySQL**. |


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

## [2. Three Tier Infrastructure App with Docker & ECR](three-tier-infra-app-docker-ecr/README.md)

### **Containerized Three-Tier App (EKS + ECR + Kafka)**

#### **Summary:**  
This project demonstrates a complete **three-tier web application** deployed on **AWS EKS** using containerized applications with **Docker** and **Amazon ECR**.

It features a **React frontend**, **Java Spring Boot backend**, **Amazon RDS MySQL** database, and **Amazon MSK** for Kafka-based event streaming.

**Description:**  
- The application uses **Kubernetes manifests** with **ConfigMaps** and **Secrets** for environment management
- **Microservices architecture** with scalable container deployments on EKS
- **Event-driven communication** between services using Amazon MSK (Managed Streaming for Apache Kafka)
- **Container registry** integration with Amazon ECR for image storage and deployment
- **Source code** available at: [react-springboot-kafka-apps](https://github.com/manvinderjit/react-springboot-kafka-apps)

**Key Technologies:** EKS, ECR, Docker, Kubernetes, MSK, RDS, ConfigMaps, Secrets

---

