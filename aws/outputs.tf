output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.filmdatahub.repository_url
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.filmdatahub.endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = aws_eks_cluster.filmdatahub.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.eks_cluster.name
}

output "eks_node_group_iam_role_name" {
  description = "IAM role name associated with EKS node group"
  value       = aws_iam_role.eks_node_group.name
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.filmdatahub.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.filmdatahub.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.filmdatahub.db_name
}

