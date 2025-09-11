variable "db_admin_username" {
  description = "The login username for the MySQL Database"
  type        = string
  sensitive   = true
}

variable "db_admin_password" {
  description = "The login password for the MySQL Database"
  type        = string
  sensitive   = true
}