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

resource "azurerm_resource_group" "filmdatahub-app" {
  name     = var.app_rg_name
  location = var.app_rg_location
}

resource "azurerm_resource_group" "filmdatahub-data" {
  name = var.data_rg_name
  location = var.data_rg_location
}

resource "azurerm_container_registry" "filmdatahub-app" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.filmdatahub-app.name
  location            = azurerm_resource_group.filmdatahub-app.location
  sku                 = var.container_registry_sku
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "filmdatahub-app" {
  name                = "filmdatahub-cluster"
  resource_group_name = azurerm_resource_group.filmdatahub-app.name
  location            = azurerm_resource_group.filmdatahub-app.location
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

resource "azurerm_role_assignment" "filmdatahub-app" {
  principal_id                     = azurerm_kubernetes_cluster.filmdatahub-app.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.filmdatahub-app.id
  skip_service_principal_aad_check = true
}

resource "azurerm_mysql_flexible_server" "filmdatahub-data" {
  name = "filmdatahub-dbserver"
  resource_group_name = azurerm_resource_group.filmdatahub-data.name
  location = azurerm_resource_group.filmdatahub-data.location
  administrator_login = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name = "B_Standard_B1ms"
}

resource "azurerm_mysql_flexible_database" "filmdatahub-data" {
  name = "filmdatahub-db"
  resource_group_name = azurerm_resource_group.filmdatahub-data.name
  server_name = azurerm_mysql_flexible_server.filmdatahub-data.name
  charset = "utf8"
  collation = "utf8_unicode_ci"
}