# Enterprise Cloud Infrastructure & Kubernetes Platform Automation

A comprehensive infrastructure-as-code solution for deploying and managing highly available, multi-AZ AWS environments with Kubernetes orchestration, full-stack observability, and security hardening.

## 🏗️ Architecture Overview

This project demonstrates end-to-end cloud infrastructure automation using:
- **AWS Services:** EC2, VPC, S3, IAM, ECR, EKS, ALB, ASG, CloudWatch
- **Infrastructure as Code:** Terraform with modular, reusable code
- **Container Orchestration:** Docker, Kubernetes, Helm
- **Observability:** Prometheus, Grafana, CloudWatch
- **Security:** VPC security groups, IAM least-privilege, fail2ban

## ✨ Key Features

### Highly Available Multi-AZ AWS Environment
- Custom VPC with public/private subnets across multiple availability zones
- NAT Gateway for private subnet internet access
- Application Load Balancer (ALB) for traffic distribution
- Auto Scaling Groups (ASG) for dynamic capacity management
- S3 for object storage with proper IAM policies
- Least-privilege IAM roles following AWS best practices

### Terraform Infrastructure Automation
- **Modular Architecture:** Reusable modules for VPC, EC2, EKS, security
- **Remote State Management:** S3 backend with DynamoDB state locking
- **Code Organization:** Separate files for variables, outputs, and resource definitions
- **Environment Separation:** Easy deployment across dev, staging, and production

### Containerized Multi-Service Application
- Docker containerization for application services
- Amazon EKS deployment with Helm charts
- Horizontal Pod Autoscaling (HPA) based on CPU/memory metrics
- Resource requests and limits for efficient utilization
- Liveness and readiness probes for self-healing deployments
- Ingress-NGINX path-based routing for microservices

### Automated Operations & Provisioning
- Python scripts using Boto3 for infrastructure validation
- Bash automation for routine operational tasks
- Cron jobs on Linux servers (RHEL/CentOS) for scheduled operations
- **Result:** Environment setup reduced from hours to ~15 minutes

### Full-Stack Observability & Security
- **Prometheus:** Metrics collection and alerting
- **Grafana:** Custom dashboards for infrastructure and application metrics
- **CloudWatch:** AWS native monitoring, alarms, and centralized logging
- **Security Hardening:**
  - VPC security group design based on CCNA networking principles
  - fail2ban intrusion prevention
  - TCP/IP, VLAN, and subnetting best practices

## 📁 Repository Structure

```
.
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── security-groups/
│   │   ├── ec2/
│   │   ├── eks/
│   │   ├── iam/
│   │   └── monitoring/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── backend.tf
├── kubernetes/
│   ├── helm-charts/
│   │   └── app-chart/
│   ├── manifests/
│   │   ├── deployments/
│   │   ├── services/
│   │   ├── ingress/
│   │   ├── hpa/
│   │   └── configmaps/
│   └── README.md
├── scripts/
│   ├── provision.py
│   ├── validate-infrastructure.py
│   ├── backup.sh
│   └── health-check.sh
├── monitoring/
│   ├── prometheus/
│   │   └── prometheus.yml
│   ├── grafana/
│   │   ├── dashboards/
│   │   └── provisioning/
│   └── README.md
├── docker/
│   ├── Dockerfile
│   └── .dockerignore
└── docs/
    ├── ARCHITECTURE.md
    ├── DEPLOYMENT.md
    ├── TROUBLESHOOTING.md
    └── SECURITY.md
```

## 🚀 Quick Start

### Prerequisites
- Terraform 1.0+
- AWS CLI configured with credentials
- Docker & Docker Compose
- kubectl & Helm 3+
- Python 3.8+

### Deploy Infrastructure

```bash
# Clone the repository
git clone git@github.com:SYBY999/-Enterprise-Cloud-Infrastructure-Kubernetes-Platform-Automation.git
cd -Enterprise-Cloud-Infrastructure-Kubernetes-Platform-Automation

# Initialize Terraform
cd terraform/environments/dev
terraform init

# Plan and apply
terraform plan -out=tfplan
terraform apply tfplan
```

### Deploy Application to EKS

```bash
cd kubernetes

# Build and push Docker image
docker build -t your-ecr-uri/app:latest docker/
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin your-ecr-uri
docker push your-ecr-uri/app:latest

# Deploy via Helm
helm install app ./helm-charts/app-chart \
  --namespace production \
  --create-namespace \
  -f helm-charts/app-chart/values-prod.yaml
```

### Set Up Monitoring

```bash
cd monitoring

# Deploy Prometheus and Grafana
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f grafana-deployment.yaml

# Port forward to access Grafana
kubectl port-forward svc/grafana 3000:80 -n monitoring
# Visit http://localhost:3000 (default: admin/admin)
```

## 📊 Key Metrics & Performance

- **Environment Setup Time:** Reduced from hours to ~15 minutes via Terraform
- **High Availability:** Multi-AZ architecture with failover capability
- **Auto-Scaling:** HPA scales pods based on real-time demand
- **Observability:** Real-time metrics from Prometheus & CloudWatch
- **Security:** VPC isolation, least-privilege IAM, intrusion prevention

## 📚 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Security Best Practices](docs/SECURITY.md)

## 🔒 Security Considerations

- ✅ Least-privilege IAM roles and policies
- ✅ VPC security groups with restricted ingress/egress
- ✅ Private subnets for sensitive resources
- ✅ S3 bucket encryption and versioning
- ✅ fail2ban for intrusion prevention
- ✅ CloudWatch alarms for security events
- ✅ Regular secrets rotation

## 🛠️ Technologies Used

| Category | Technologies |
|----------|---------------|
| **Infrastructure** | Terraform, AWS (EC2, VPC, EKS, S3, IAM, ALB, ASG, CloudWatch) |
| **Containerization** | Docker, Amazon ECR |
| **Orchestration** | Kubernetes (EKS), Helm |
| **Observability** | Prometheus, Grafana, CloudWatch |
| **Scripting** | Python (Boto3), Bash |
| **OS** | Linux (RHEL/CentOS) |
| **Networking** | TCP/IP, VLANs, Subnetting, CCNA Principles |

## 📈 Roadmap

- [ ] Add multi-region failover capabilities
- [ ] Implement GitOps workflow with ArgoCD
- [ ] Add infrastructure cost optimization analysis
- [ ] Implement disaster recovery automation
- [ ] Add compliance scanning (CIS benchmarks)

## 🤝 Contributing

Contributions are welcome! Please follow the existing code style and include documentation for new features.

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**SYBY999**

---

## ❓ Support

For issues, questions, or suggestions:
1. Check [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. Review existing GitHub Issues
3. Open a new Issue with detailed information

---

**Last Updated:** July 2026  
**Terraform Version:** 1.0+  
**Kubernetes Version:** 1.27+
