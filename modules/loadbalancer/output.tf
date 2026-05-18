output "lb_id" {
  description = "The ID of the Load Balancer"
  value       = azurerm_lb.public_lb.id
}

output "lb_backend_address_pool_id" {
  description = "The ID of the LB Backend Address Pool"
  value       = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

output "lb_public_ip_address" {
  description = "The public IP address of the Load Balancer"
  value       = azurerm_public_ip.lb_ip.ip_address
}

output "lb_public_ip_fqdn" {
  description = "The FQDN of the Load Balancer public IP"
  value       = azurerm_public_ip.lb_ip.fqdn
}

output "lb_probe_id" {
  description = "The ID of the Load Balancer health probe"
  value       = azurerm_lb_probe.lb_probe.id
}
