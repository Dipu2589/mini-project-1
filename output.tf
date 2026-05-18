output "load_balancer_public_ip" {
  description = "The public IP address of the Load Balancer"
  value       = module.loadbalancer.lb_public_ip_address
}

output "load_balancer_fqdn" {
  description = "The FQDN of the Load Balancer public IP"
  value       = module.loadbalancer.lb_public_ip_fqdn
}

output "vmss_id" {
  description = "The ID of the Virtual Machine Scale Set"
  value       = module.vmss.vmss_id
}

output "nat_gateway_public_ip" {
  description = "The public IP address of the NAT Gateway"
  value       = module.networks.nat_gateway_public_ip
}
