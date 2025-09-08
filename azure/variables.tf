variable "subscription_id" {
  description = "The subscription id for the Azure account"
  type        = string
  default     = "1a0a6d17-04fa-4014-b67e-a70b121d990c"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type = string
  default = "FilmDataHubRG"
}

variable "resource_group_location" {
  description = "The Azure region where the database resource group will be created."
  type = string
  default = "South Central US"
}

variable "container_image_name" {
  description = "The name of the container image to be used in the container group."
  type        = string
  default     = "filmdatahub"
}

variable "container_registry_name" {
  description = "The name of the Azure Container Registry."
  type        = string
  default     = "filmdatahubregistry"
}

variable "db_admin_username" {
  description = "The login username for the MySQL Database"
  type        = string
  default     = "user123"
  sensitive   = true
}

variable "db_admin_password" {
  description = "The login password for the MySQL Database"
  type        = string
  default     = "Pass123!"
  sensitive   = true
}