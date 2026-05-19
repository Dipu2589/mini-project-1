terraform {
  backend "azurerm" {
    use_oidc             = true
    use_azuread_auth     = true
    tenant_id            = "9d99d290-b524-4e26-b141-f64b65f0ee42"
    client_id            = "d222ab5-aa54-4574-b53c-81a48e67c153"
    storage_account_name = "aztfdevstatefile"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}