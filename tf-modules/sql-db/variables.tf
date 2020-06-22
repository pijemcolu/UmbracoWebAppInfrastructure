variable "location" {
  description = "Location"
}

variable "location_acronym" {
  description = "Default infix for resources. Used in a naming convention {resource_type}-{service-name}-{LOCATION_INFIX}-{env_sufix}"
}

variable "rg_name" {
  description = "Resource group where sql database will be created"
}

variable "sql_edition" {
  description = "Azure Sql database edition"
}

variable "db_name" {
  description = "Database name used in naming convention sqldb-{var.db_name}-{var.location_infix}-{var.env_suffix}"
}

variable "sql_username" {
  description = "Username for the new database user"
}

