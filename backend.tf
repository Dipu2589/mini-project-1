terraform {
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    tenant_id            = var.tenant_id
    client_id            = var.client_id
    storage_account_name = "aztfdevstatefile"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}