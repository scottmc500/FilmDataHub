terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.1.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "TerraformResourceGroup"
    storage_account_name = "scottsterraformstorage"
    container_name       = "tfstate"
    key                  = "filmdatahub.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "filmdatahub" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_container_registry" "filmdatahub" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.filmdatahub.name
  location            = azurerm_resource_group.filmdatahub.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "filmdatahub" {
  name                = "filmdatahub-cluster"
  resource_group_name = azurerm_resource_group.filmdatahub.name
  location            = azurerm_resource_group.filmdatahub.location
  dns_prefix          = "filmdatahub"
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  default_node_pool {
    name                        = "default"
    node_count                  = 1
    vm_size                     = "standard_a2_v2"
    temporary_name_for_rotation = "blah123"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "filmdatahub" {
  principal_id                     = azurerm_kubernetes_cluster.filmdatahub.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.filmdatahub.id
  skip_service_principal_aad_check = true
}

resource "azurerm_mysql_flexible_server" "filmdatahub" {
  name = "filmdatahub-dbserver"
  resource_group_name = azurerm_resource_group.filmdatahub.name
  location = azurerm_resource_group.filmdatahub.location
  administrator_login = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name = "B_Standard_B1ms"
}

# Firewall rule to allow access from AKS cluster only
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_aks_only" {
  name                = "AllowAKSOnly"
  resource_group_name = azurerm_resource_group.filmdatahub.name
  server_name         = azurerm_mysql_flexible_server.filmdatahub.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_flexible_database" "filmdatahub" {
  name = "filmdatahub-db"
  resource_group_name = azurerm_resource_group.filmdatahub.name
  server_name = azurerm_mysql_flexible_server.filmdatahub.name
  charset = "utf8"
  collation = "utf8_unicode_ci"
}