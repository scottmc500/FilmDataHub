output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.filmdatahub.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.filmdatahub.location
}

output "container_registry_login_server" {
  description = "The login server URL of the container registry"
  value       = azurerm_container_registry.filmdatahub.login_server
}

output "container_registry_admin_username" {
  description = "The admin username for the container registry"
  value       = azurerm_container_registry.filmdatahub.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "The admin password for the container registry"
  value       = azurerm_container_registry.filmdatahub.admin_password
  sensitive   = true
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.filmdatahub.name
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster"
  value       = azurerm_kubernetes_cluster.filmdatahub.fqdn
}

output "aks_cluster_private_fqdn" {
  description = "The private FQDN of the Azure Kubernetes Managed Cluster"
  value       = azurerm_kubernetes_cluster.filmdatahub.private_fqdn
}

output "aks_cluster_portal_fqdn" {
  description = "The FQDN for the Azure Portal resources when private link is enabled"
  value       = azurerm_kubernetes_cluster.filmdatahub.portal_fqdn
}

output "aks_cluster_kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = azurerm_kubernetes_cluster.filmdatahub.kube_config_raw
  sensitive   = true
}

output "aks_cluster_kube_config_host" {
  description = "The Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.filmdatahub.kube_config.0.host
  sensitive   = true
}

output "aks_cluster_identity_principal_id" {
  description = "The Principal ID associated with this Managed Service Identity"
  value       = azurerm_kubernetes_cluster.filmdatahub.identity[0].principal_id
}

output "aks_cluster_kubelet_identity_object_id" {
  description = "The Object ID of the user assigned identity for kubelet"
  value       = azurerm_kubernetes_cluster.filmdatahub.kubelet_identity[0].object_id
}

output "mysql_server_name" {
  description = "The name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.filmdatahub.name
}

output "mysql_server_fqdn" {
  description = "The FQDN of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.filmdatahub.fqdn
}

output "mysql_server_administrator_login" {
  description = "The administrator login name for the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.filmdatahub.administrator_login
  sensitive   = true
}

output "mysql_database_name" {
  description = "The name of the MySQL database"
  value       = azurerm_mysql_flexible_database.filmdatahub.name
}

output "mysql_database_charset" {
  description = "The charset of the MySQL database"
  value       = azurerm_mysql_flexible_database.filmdatahub.charset
}

output "mysql_database_collation" {
  description = "The collation of the MySQL database"
  value       = azurerm_mysql_flexible_database.filmdatahub.collation
}

output "mysql_firewall_rule_name" {
  description = "The name of the MySQL firewall rule"
  value       = azurerm_mysql_flexible_server_firewall_rule.allow_aks_only.name
}

output "mysql_firewall_rule_start_ip" {
  description = "The starting IP address of the MySQL firewall rule"
  value       = azurerm_mysql_flexible_server_firewall_rule.allow_aks_only.start_ip_address
}

output "mysql_firewall_rule_end_ip" {
  description = "The ending IP address of the MySQL firewall rule"
  value       = azurerm_mysql_flexible_server_firewall_rule.allow_aks_only.end_ip_address
}

output "acr_pull_role_assignment_id" {
  description = "The ID of the role assignment for ACR pull access"
  value       = azurerm_role_assignment.filmdatahub.id
}

output "acr_pull_principal_id" {
  description = "The principal ID for the ACR pull role assignment"
  value       = azurerm_role_assignment.filmdatahub.principal_id
}

output "acr_pull_role_definition_name" {
  description = "The role definition name for the ACR pull role assignment"
  value       = azurerm_role_assignment.filmdatahub.role_definition_name
}
