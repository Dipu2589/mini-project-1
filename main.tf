# Creates Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Networking Module — VNet, Subnet, NSG, NAT Gateway
module "networks" {
  source = "./modules/networks"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Load Balancer Module — Public IP, LB, Backend Pool, Rules, Probes
module "loadbalancer" {
  source = "./modules/loadbalancer"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# VMSS Module — Orchestrated Scale Set + Autoscale Rules
module "vmss" {
  source = "./modules/vmss"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  subnet_id                  = module.networks.subnet_id
  lb_backend_address_pool_id = module.loadbalancer.lb_backend_address_pool_id
  lb_id                      = module.loadbalancer.lb_id
}
