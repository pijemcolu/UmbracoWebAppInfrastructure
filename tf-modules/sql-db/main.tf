locals {
  connection_string        = "Server=tcp:${azurerm_sql_server.server.name}.database.windows.net;Database=${azurerm_sql_database.db.name};User ID=${var.sql_username}@${azurerm_sql_server.server.name};Password=${random_password.sql_password.result};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  server_connection_string = "Server=tcp:${azurerm_sql_server.server.fully_qualified_domain_name},1433;Initial Catalog=master;Persist Security Info=False;User ID=${azurerm_sql_server.server.administrator_login};Password=${azurerm_sql_server.server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}

resource "azurerm_sql_server" "server" {
  name                         = "sqlsrv-${var.db_name}-${var.location_acronym}"
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_firewall_rule" "allow_all" {
  name                = "Allow All"
  resource_group_name = var.rg_name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_sql_database" "db" {
  name                = "sqldb-${var.db_name}-${var.location_acronym}"
  resource_group_name = var.rg_name
  location            = var.location
  server_name         = azurerm_sql_server.server.name
  edition             = var.sql_edition
}

resource "null_resource" "create_sql_user" {
  provisioner "local-exec" {
    command     = ".'${path.module}\\scripts\\create-sql-user.ps1' -password \"${random_password.sql_password.result}\" -username \"${var.sql_username}\" -sqlSaConnectionString \"${local.server_connection_string}\" -databaseName \"${azurerm_sql_database.db.name}\" "
    interpreter = ["pwsh", "-Command"]
  }
  depends_on = [azurerm_sql_database.db]
}

resource "random_password" "sql_password" {
  length           = 54
  special          = false
  override_special = "$%@&*()"
}

