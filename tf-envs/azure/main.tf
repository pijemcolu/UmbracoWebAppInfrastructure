resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.instance_id}"
  location = var.location
}

module "umbraco-web-app" {
  source           = "../../tf-modules/umbraco-web-app"
  location_acronym = var.location_acronym
  location         = azurerm_resource_group.rg.location

  app_name           = var.instance_id
  rg_name            = azurerm_resource_group.rg.name
  package_source_url = var.package_source_url
}

module "sql-db" {
  source           = "../../tf-modules/sql-db"
  location_acronym = var.location_acronym
  location         = azurerm_resource_group.rg.location

  rg_name      = azurerm_resource_group.rg.name
  sql_edition  = "Basic"
  db_name      = var.instance_id
  sql_username = "sqluser"
}
