provider "azurerm" {
  version         = "=1.40.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
terraform {
  required_version = ">= 0.12.15"
  backend "azurerm" {
    resource_group_name  = "rg-storage-we-umb-cloud-test"
    storage_account_name = "saterraformstatewe216"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}