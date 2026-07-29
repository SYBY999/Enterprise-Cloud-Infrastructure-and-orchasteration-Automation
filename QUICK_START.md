# Quick Start Guide

## 🚀 Setup Your Repository in 3 Steps

### Step 1: Download the Setup Files
All files are ready for you:
- `README.md` - Full project documentation
- `.gitignore` - Git ignore patterns
- `setup-repo.sh` - Automated setup script

### Step 2: Run the Setup Script Locally

```bash
# Make the script executable
chmod +x setup-repo.sh

# Run it (this creates directory structure and pushes to GitHub)
./setup-repo.sh
```

The script will:
- ✅ Check SSH connection to GitHub
- ✅ Create the full directory structure
- ✅ Generate template files (Terraform, Kubernetes, Python, Bash)
- ✅ Initialize git repository
- ✅ Commit all files
- ✅ Push to your GitHub repository

### Step 3: Verify on GitHub

Visit: `https://github.com/SYBY999/-Enterprise-Cloud-Infrastructure-Kubernetes-Platform-Automation`

You should see:
- README.md with full documentation
- Directory structure with templates
- All configuration files

---

## 📋 What's Included

### Documentation
- **README.md** - Complete project overview and instructions
- **QUICK_START.md** - This file

### Directory Structure
```
terraform/              # Infrastructure as Code
  ├── modules/         # Reusable modules (VPC, EKS, IAM, etc.)
  └── environments/    # Dev, staging, prod configurations

kubernetes/            # Kubernetes & Helm
  ├── helm-charts/    # Helm chart templates
  └── manifests/      # K8s deployments, services, ingress

scripts/              # Automation scripts
  ├── provision.py   # Python infrastructure validation
  └── health-check.sh # Bash health check script

monitoring/           # Observability
  ├── prometheus/    # Prometheus configuration
  └── grafana/       # Grafana dashboards

docker/              # Container images
docs/               # Additional documentation
```

### Template Files
- `terraform/main.tf`, `variables.tf`, `outputs.tf` - Terraform templates
- `kubernetes/manifests/deployments/app-deployment.yaml` - K8s deployment example
- `kubernetes/helm-charts/app-chart/Chart.yaml` - Helm chart structure
- `scripts/provision.py` - Python automation example
- `scripts/health-check.sh` - Bash automation example

---

## ⚙️ Prerequisites

Before running the setup script, ensure you have:

```bash
# Check each tool is installed
git --version           # Git 2.0+
ssh -V                  # OpenSSH
terraform --version    # Terraform 1.0+ (for later)
```

### Configure SSH (if not already done)

```bash
# Test SSH connection
ssh -T git@github.com

# If it fails, generate a new SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Then add the public key to GitHub:
# https://github.com/settings/keys
# cat ~/.ssh/id_ed25519.pub  # Copy this
```

---

## 🔄 After Initial Setup

### Add Your Actual Code

Replace template files with your real infrastructure:

```bash
# Terraform
cp your-terraform-code/* terraform/

# Kubernetes
cp your-k8s-manifests/* kubernetes/

# Scripts
cp your-scripts/* scripts/
```

### Commit and Push Changes

```bash
git add .
git commit -m "Add actual infrastructure code"
git push origin main
```

### Create Additional Documentation

Add to the `docs/` folder:
- `ARCHITECTURE.md` - Architecture diagrams and explanations
- `DEPLOYMENT.md` - Step-by-step deployment instructions
- `TROUBLESHOOTING.md` - Common issues and solutions
- `SECURITY.md` - Security best practices

---

## 📝 Customization

Edit these files to match your setup:

### terraform/variables.tf
```hcl
variable "aws_region" {
  default = "us-east-1"  # Change to your region
}

variable "environment" {
  default = "dev"  # Or "staging", "prod"
}
```

### kubernetes/helm-charts/app-chart/values.yaml
```yaml
image:
  repository: your-ecr-uri/app  # Your ECR repository
  tag: latest
replicas: 3
```

---

## ✅ Troubleshooting

### SSH Connection Failed
```bash
# Debug SSH connection
ssh -vvv git@github.com

# Verify key is added
ssh-add -l
```

### Git Push Failed
```bash
# Check remote URL
git remote -v

# Update remote if needed
git remote set-url origin git@github.com:SYBY999/-Enterprise-Cloud-Infrastructure-Kubernetes-Platform-Automation.git

# Force push initial setup
git push -u origin main --force
```

### Permission Denied
```bash
# Ensure script is executable
chmod +x setup-repo.sh

# Run with bash explicitly
bash setup-repo.sh
```

---

## 📚 Next Steps

1. ✅ Run `setup-repo.sh` to initialize repository
2. 📖 Read `README.md` for full documentation
3. 🔧 Add your Terraform configuration
4. 🐳 Add your Docker/Kubernetes manifests
5. 📊 Add your monitoring configuration
6. 🔐 Review `docs/SECURITY.md` for best practices
7. 📤 Commit and push your changes

---

## 🆘 Need Help?

Check these resources:
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Terraform Registry](https://registry.terraform.io/)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [GitHub Help](https://docs.github.com/)

---

**Ready to start?**

```bash
chmod +x setup-repo.sh
./setup-repo.sh
```

Good luck! 🚀
