output "subnet_id" {
  description = "The ID of the public subnet"
  value       = azurerm_subnet.public_subnet.id
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "nsg_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.subnet_nsg.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.natgwp.id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = azurerm_public_ip.natgateway_ip.ip_address
}
