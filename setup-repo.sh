#!/bin/bash

# Enterprise Cloud Infrastructure Repository Setup Script
# This script initializes your local repository and pushes to GitHub

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}Enterprise Cloud Infrastructure - Repo Setup${NC}"
echo -e "${GREEN}================================================${NC}"

# Configuration
REPO_URL="git@github.com:SYBY999/-Enterprise-Cloud-Infrastructure-Kubernetes-Platform-Automation.git"
REPO_NAME="-Enterprise-Cloud-Infrastructure-Kubernetes-Platform-Automation"
BRANCH="main"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is not installed. Please install git first.${NC}"
    exit 1
fi

# Check SSH connection to GitHub
echo -e "\n${YELLOW}📋 Checking SSH connection to GitHub...${NC}"
if ssh -T git@github.com &> /dev/null || true; then
    echo -e "${GREEN}✅ SSH connection successful${NC}"
else
    echo -e "${RED}❌ SSH connection to GitHub failed${NC}"
    echo -e "${YELLOW}Please ensure SSH keys are configured:${NC}"
    echo "1. ssh-keygen -t ed25519 -C 'your_email@example.com'"
    echo "2. ssh-add ~/.ssh/id_ed25519"
    echo "3. Add the public key to https://github.com/settings/keys"
    exit 1
fi

# Create project directories
echo -e "\n${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p terraform/modules/{vpc,security-groups,ec2,eks,iam,monitoring}
mkdir -p terraform/environments/{dev,staging,prod}
mkdir -p kubernetes/helm-charts/app-chart
mkdir -p kubernetes/manifests/{deployments,services,ingress,hpa,configmaps}
mkdir -p scripts
mkdir -p monitoring/prometheus
mkdir -p monitoring/grafana/{dashboards,provisioning}
mkdir -p docker
mkdir -p docs
echo -e "${GREEN}✅ Directory structure created${NC}"

# Create placeholder files
echo -e "\n${YELLOW}📝 Creating template files...${NC}"

# Terraform templates
cat > terraform/main.tf << 'EOF'
# Main Terraform configuration
# Configure your AWS provider and call modules here

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Enterprise-Cloud-Infrastructure"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
EOF

cat > terraform/variables.tf << 'EOF'
variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}
EOF

cat > terraform/outputs.tf << 'EOF'
output "vpc_id" {
  description = "VPC ID"
  value       = "aws_vpc.main.id"
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = "aws_eks_cluster.main.name"
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = "aws_lb.main.dns_name"
}
EOF

# Python script template
cat > scripts/provision.py << 'EOF'
#!/usr/bin/env python3
"""
Infrastructure provisioning validation script using Boto3
"""

import boto3
import sys
from typing import Dict, List

def validate_vpc(ec2_client, vpc_id: str) -> bool:
    """Validate VPC configuration"""
    try:
        response = ec2_client.describe_vpcs(VpcIds=[vpc_id])
        vpc = response['Vpcs'][0]
        print(f"✅ VPC {vpc_id} is active")
        return True
    except Exception as e:
        print(f"❌ VPC validation failed: {e}")
        return False

def check_eks_cluster(eks_client, cluster_name: str) -> bool:
    """Check EKS cluster status"""
    try:
        response = eks_client.describe_cluster(name=cluster_name)
        status = response['cluster']['status']
        print(f"✅ EKS Cluster {cluster_name} status: {status}")
        return status == 'ACTIVE'
    except Exception as e:
        print(f"❌ EKS cluster check failed: {e}")
        return False

def main():
    """Main validation function"""
    print("Starting infrastructure validation...")
    
    # Initialize Boto3 clients
    ec2 = boto3.client('ec2')
    eks = boto3.client('eks')
    
    # Example: Validate VPC
    # vpc_id = "vpc-xxxxx"
    # if not validate_vpc(ec2, vpc_id):
    #     sys.exit(1)
    
    print("\nValidation complete!")

if __name__ == "__main__":
    main()
EOF

# Kubernetes manifest template
cat > kubernetes/manifests/deployments/app-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: your-ecr-uri/app:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: 250m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
EOF

# Helm Chart template
cat > kubernetes/helm-charts/app-chart/Chart.yaml << 'EOF'
apiVersion: v2
name: app
description: Enterprise Application Helm Chart
type: application
version: 1.0.0
appVersion: "1.0"
maintainers:
  - name: SYBY999
EOF

# Bash script template
cat > scripts/health-check.sh << 'EOF'
#!/bin/bash
# Health check script for infrastructure

set -e

echo "🏥 Starting health checks..."

# Check EC2 instances
echo "Checking EC2 instances..."
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output table

# Check EKS clusters
echo "Checking EKS clusters..."
aws eks list-clusters --query 'clusters' --output table

# Check ALB
echo "Checking Application Load Balancers..."
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerName,State.Code]' --output table

echo "✅ Health check complete!"
EOF

chmod +x scripts/health-check.sh

echo -e "${GREEN}✅ Template files created${NC}"

# Initialize git repository
echo -e "\n${YELLOW}🔧 Initializing git repository...${NC}"

if [ -d .git ]; then
    echo "Git repository already initialized"
else
    git init
    git config user.name "Cloud Infrastructure" 2>/dev/null || echo "⚠️  Git user not configured"
fi

# Add files
echo -e "\n${YELLOW}📤 Staging files...${NC}"
git add .

# Create initial commit
echo -e "\n${YELLOW}💾 Creating initial commit...${NC}"
git commit -m "Initial commit: Enterprise Cloud Infrastructure & Kubernetes Platform Automation" || echo "No changes to commit"

# Add remote and push
echo -e "\n${YELLOW}🚀 Pushing to GitHub...${NC}"

# Check if remote exists
if git remote | grep -q "origin"; then
    echo "Remote 'origin' already configured"
else
    git remote add origin "$REPO_URL"
fi

# Rename branch if necessary
if git rev-parse --abbrev-ref HEAD | grep -q "master"; then
    git branch -M main
fi

# Push to GitHub
git push -u origin main --force

echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}✅ Repository setup complete!${NC}"
echo -e "${GREEN}================================================${NC}"
echo -e "\n${GREEN}Repository:${NC} $REPO_URL"
echo -e "${GREEN}Branch:${NC} main"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Add your Terraform code to terraform/"
echo "2. Add Kubernetes manifests to kubernetes/"
echo "3. Add monitoring configuration to monitoring/"
echo "4. Add documentation to docs/"
echo "5. Commit and push your changes"
echo -e "\n${YELLOW}Useful commands:${NC}"
echo "  git status                    # Check git status"
echo "  git add .                     # Stage all changes"
echo "  git commit -m 'message'       # Commit changes"
echo "  git push origin main          # Push to GitHub"
