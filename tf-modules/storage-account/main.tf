## Persistence - Storage account & SQL
# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = "sa${var.name}${var.location_acronym}"
  resource_group_name      = var.rg_name
  location                 = var.primary_location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.name}${var.location_acronym}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "blob"
}