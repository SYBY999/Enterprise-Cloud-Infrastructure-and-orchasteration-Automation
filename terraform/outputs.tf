output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.main.name
}

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_lb.main.dns_name
}
