#!/bin/bash
set -e

echo "Starting health checks..."

echo "Checking EC2 instances..."
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output table

echo "Checking EKS clusters..."
aws eks list-clusters --query 'clusters' --output table

echo "Checking Application Load Balancers..."
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerName,State.Code]' --output table

echo "Health check complete!"
