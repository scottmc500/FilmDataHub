# Container Registry Outputs (equivalent to ECR)
output "acr_repository_url" {
  description = "The URL of the Azure Container Registry"
  value       = azurerm_container_registry.filmdatahub.login_server
}

output "acr_admin_username" {
  description = "The admin username for the Azure Container Registry"
  value       = azurerm_container_registry.filmdatahub.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "The admin password for the Azure Container Registry"
  value       = azurerm_container_registry.filmdatahub.admin_password
  sensitive   = true
}

# Kubernetes Cluster Outputs (equivalent to EKS)
output "aks_cluster_endpoint" {
  description = "Endpoint for AKS control plane"
  value       = azurerm_kubernetes_cluster.filmdatahub.fqdn
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.filmdatahub.name
}

output "aks_cluster_identity_principal_id" {
  description = "The Principal ID associated with the AKS cluster managed identity"
  value       = azurerm_kubernetes_cluster.filmdatahub.identity[0].principal_id
}

output "aks_node_pool_identity_object_id" {
  description = "The Object ID of the user assigned identity for kubelet"
  value       = azurerm_kubernetes_cluster.filmdatahub.kubelet_identity[0].object_id
}

output "aks_kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = azurerm_kubernetes_cluster.filmdatahub.kube_config_raw
  sensitive   = true
}

# Database Outputs (equivalent to RDS)
output "mysql_endpoint" {
  description = "MySQL Flexible Server endpoint"
  value       = azurerm_mysql_flexible_server.filmdatahub.fqdn
}

output "mysql_port" {
  description = "MySQL Flexible Server port"
  value       = 3306
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = azurerm_mysql_flexible_database.filmdatahub.name
}

output "mysql_administrator_login" {
  description = "MySQL Flexible Server administrator login"
  value       = azurerm_mysql_flexible_server.filmdatahub.administrator_login
  sensitive   = true
}