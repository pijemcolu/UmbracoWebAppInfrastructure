## Service principal variables
variable "subscription_id" {
}
variable "client_id" {
}
variable "client_secret" {
}
variable "tenant_id" {
}

## Resource Provider configuration
provider "azurerm" {
  version         = "=1.40.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

## Hello World Resource group
resource "azurerm_resource_group" "tf_identifier" {
  name     = "rg-hello_world"
  location = "West Europe"
}
