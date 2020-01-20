## Web
# App Service Plan
resource "azurerm_app_service_plan" "appplan" {
  name                = "azappsp-${var.app_name}-${var.location_acronym}"
  location            = var.location
  resource_group_name = var.rg_name

  sku {
    tier = "Standard"
    size = "S1"
  }
}
# App Service
resource "azurerm_app_service" "appservice" {
  name                = "azapps-${var.app_name}-${var.location_acronym}"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.appplan.id

  site_config {
    dotnet_framework_version = "v4.0"
  }

  app_settings = {
    "UmbracoDbDSN"                         = var.db_connection_string
  }
}

resource "null_resource" "deploy" {
  provisioner "local-exec" {
    command     = ".'${path.module}\\scripts\\deploy.ps1' -ResourceGroupName \"${var.rg_name}\" -AppName \"${azurerm_app_service.appservice.name}\""
    interpreter = ["pwsh", "-Command"]
  }
}
