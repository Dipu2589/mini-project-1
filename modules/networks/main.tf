# Creates VNet
resource "azurerm_virtual_network" "vnet" {
  name                = "public-vnet"
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
  location            = var.location
}

# Creates Subnet under VNet
resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Creates Network Security Group
resource "azurerm_network_security_group" "subnet_nsg" {
  name                = "subnet-nsg"
  resource_group_name = var.resource_group_name
  location            = var.location
  
security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-ssh"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associates NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.public_subnet.id
  network_security_group_id = azurerm_network_security_group.subnet_nsg.id
}

# Creates Public IP for NAT Gateway
resource "azurerm_public_ip" "natgateway_ip" {
  name                = "natgateway-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

# Creates NAT Gateway
resource "azurerm_nat_gateway" "natgwp" {
  name                = "natgwp"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Associates NAT Gateway to Subnet
resource "azurerm_subnet_nat_gateway_association" "natsubnet_link" {
  subnet_id      = azurerm_subnet.public_subnet.id
  nat_gateway_id = azurerm_nat_gateway.natgwp.id
}

# Associates Public IP to NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "natgwp_link" {
  public_ip_address_id = azurerm_public_ip.natgateway_ip.id
  nat_gateway_id       = azurerm_nat_gateway.natgwp.id
}
