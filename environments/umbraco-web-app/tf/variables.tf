variable "client_secret" {
  description = "Azure provider client secret"
}
variable "tenant_id" {
  description = "Azure subscription tenant id."
}

variable "client_id" {
  description = "Azure provider Azure AD client id."
}

variable "subscription_id" {
  description = "Azure subscription id."
}

variable "pfx_password" {
  description = "TLS .pfx certificate password for the custom domain mikulas.dev"
}

variable "location" {
  description = "Default location"
  default     = "West Europe"
}

variable "location_acronym" {
  description = "Acronym use for naking purposes for the default location"
  default     = "we"
}

variable "name" {
  description = "Name for the module used when naming resources"
  default     = "azarchdemo"
}

variable "domain" {
  description = "Domain used for the app"
  default     = "mikulas.dev"
}

variable "frontdoor_object_id" {
  description = "Object Id of the service principal for Microsoft.Azure.FrontDoor"
  default     = "fee7f6da-69af-414e-8b08-b361d926cf3f"
}
