# Enterprise Cloud Infrastructure & Kubernetes Platform Automation

Infrastructure-as-code project for a highly available, multi-AZ AWS environment with Kubernetes orchestration, observability, and security hardening.

## Stack
- **IaC:** Terraform (modular, remote state via S3 + DynamoDB locking)
- **AWS:** EC2, VPC, S3, IAM, ECR, EKS, ALB, ASG, CloudWatch
- **Containers:** Docker, Kubernetes (EKS), Helm
- **Automation:** Python (Boto3), Bash, Cron on Linux (RHEL/CentOS)
- **Observability & Security:** Prometheus, Grafana, CloudWatch, fail2ban

## Highlights
- Custom multi-AZ VPC with public/private subnets, NAT Gateway, ALB, and Auto Scaling Groups
- Multi-service app containerized and deployed to EKS via Helm, with HPA, resource limits, liveness/readiness probes, and Ingress-NGINX path-based routing
- Python/Bash automation cut environment setup time from hours to roughly 15 minutes
- Full-stack monitoring dashboards and VPC security-group design grounded in CCNA networking principles (TCP/IP, VLANs, subnetting)

## Structure
Terraform modules, Kubernetes manifests, and automation scripts to follow.
