variable "rg_name" {
  description = "Name of the resource group."
}

variable "app_name" {
  description = "Name for the app."
}

variable "db_connection_string" {
  description = "Connection string for the sql database"
  default = ""
}


variable "location_acronym" {
  description = "acronym used for naming resources, describing the region."
}

variable "location" {
  description = "Location of deployment of the resources."
}
