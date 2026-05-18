output "vmss_id" {
  description = "The ID of the Virtual Machine Scale Set"
  value       = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  description = "The name of the Virtual Machine Scale Set"
  value       = azurerm_orchestrated_virtual_machine_scale_set.vmss.name
}

output "autoscale_setting_id" {
  description = "The ID of the autoscale setting"
  value       = azurerm_monitor_autoscale_setting.autoscale.id
}
