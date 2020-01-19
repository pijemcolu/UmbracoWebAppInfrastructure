# SP ids
data "azurerm_client_config" "current" {}

## Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}-${var.location_acronym}"
  location = var.location
}

### Prepared DNS section
## DNS
resource "azurerm_dns_zone" "dns" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.rg.name
}
# CNAME www record
resource "azurerm_dns_cname_record" "cname" {
  name                = "www"
  zone_name           = azurerm_dns_zone.dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 60
  record              = "fd-azarchdemo.azurefd.net"
}

## DNS Routing - Front Door
resource "azurerm_frontdoor" "fd" {
  name                                         = "fd-${var.name}"
  location                                     = azurerm_resource_group.rg.location
  resource_group_name                          = azurerm_resource_group.rg.name
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "webRoutingRules"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["frontend"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "Backend"
    }
  }

  backend_pool_load_balancing {
    name = "LoadBalancingSettings"
  }

  backend_pool_health_probe {
    name = "HealthProbeSetting"
  }

  backend_pool {
    name = "Backend"
    backend {
      host_header = "dummy.com"
      address     = "dummy.com"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "LoadBalancingSettings"
    health_probe_name   = "HealthProbeSetting"
  }

  frontend_endpoint {
    name                              = "frontend"
    host_name                         = "www.${var.domain}"
    custom_https_provisioning_enabled = true
    custom_https_configuration {
      certificate_source                         = "AzureKeyVault"
      azure_key_vault_certificate_vault_id       = azurerm_key_vault.kv.id
      azure_key_vault_certificate_secret_name    = azurerm_key_vault_certificate.certificate.name
      azure_key_vault_certificate_secret_version = azurerm_key_vault_certificate.certificate.version
    }
  }
}


## Keyvault & apex domain certificate for mikulas.dev
# Keyvault
resource "azurerm_key_vault" "kv" {
  name                = "kv-${var.name}-${var.location_acronym}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"
}
# Certificate for mikulas.dev
resource "azurerm_key_vault_certificate" "certificate" {
  name         = "apex"
  key_vault_id = azurerm_key_vault.kv.id

  certificate {
    contents = filebase64("mikulas.dev.pfx")
    password = var.pfx_password
  }

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = false
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }
  }
}

# Terraform KV Access Policy
resource "azurerm_key_vault_access_policy" "tf" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.service_principal_object_id

  certificate_permissions = [
    "create",
    "delete",
    "get",
    "import",
    "list",
    "update",
  ]

  key_permissions = [
    "create",
    "delete",
    "get",
    "import",
    "list",
    "update",
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set",
  ]
}
# Terraform KV Access Policy
resource "azurerm_key_vault_access_policy" "fd" {
  key_vault_id = azurerm_key_vault.kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = var.frontdoor_object_id

  certificate_permissions = [
    "get"
  ]

  secret_permissions = [
    "get"
  ]
}

## Here come the modules

