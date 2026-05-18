resource "random_pet" "lb_hostname" {}

# Creates Public IP for Load Balancer
resource "azurerm_public_ip" "lb_ip" {
  name                = "lb-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = "${var.resource_group_name}-${random_pet.lb_hostname.id}"
}

# Creates Public Load Balancer
resource "azurerm_lb" "public_lb" {
  name                = "public_lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "public-ip"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

# Creates Backend Address Pool
resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name            = "lb-backend-pool"
  loadbalancer_id = azurerm_lb.public_lb.id
}

# Health Probe on port 80
resource "azurerm_lb_probe" "lb_probe" {
  name            = "lb-probe"
  loadbalancer_id = azurerm_lb.public_lb.id
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}

# LB Rule — HTTP traffic on port 80
resource "azurerm_lb_rule" "lb_rule_http" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.public_lb.id
  frontend_port                  = 80
  backend_port                   = 80
  protocol                       = "Tcp"
  frontend_ip_configuration_name = "public-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

# NAT Rule — SSH access via port range 50000–50119
resource "azurerm_lb_nat_rule" "lb_nat_rule" {
  name                           = "lb-nat-rule"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.public_lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "public-ip"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
}
