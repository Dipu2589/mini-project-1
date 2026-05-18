# Provisions Orchestrated Virtual Machine Scale Set
resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
  name                        = "vmss"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  sku_name                    = var.vm_sku
  instances                   = var.instance_count
  platform_fault_domain_count = 1
  zones                       = ["1"]

  user_data_base64 = base64encode(file("${path.module}/user-data.sh"))

  os_profile {
    linux_configuration {
      disable_password_authentication = true
      admin_username                  = var.admin_username
      admin_ssh_key {
        username   = var.admin_username
        public_key = file("${path.module}/ssh/key.pub")
      }
    }
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name                          = "NIC"
    primary                       = true
    enable_accelerated_networking = false

    ip_configuration {
      name                                   = "ipconfig"
      primary                                = true
      subnet_id                              = var.subnet_id
      load_balancer_backend_address_pool_ids = [var.lb_backend_address_pool_id]
    }
  }

  boot_diagnostics {
    storage_account_uri = ""
  }

  lifecycle {
    ignore_changes = [instances]
  }
}

# Autoscale Rules — scale out/in based on CPU utilisation
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale-rule"
  location            = var.location
  resource_group_name = var.resource_group_name
  target_resource_id  = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
  enabled             = true

  profile {
    name = "autoscale"

    capacity {
      default = var.autoscale_default
      minimum = var.autoscale_min
      maximum = var.autoscale_max
    }

    # Scale OUT — CPU > 80%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_threshold
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"

        dimensions {
          name     = "AppName"
          operator = "Equals"
          values   = ["App1"]
        }
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = tostring(var.scale_out_count)
        cooldown  = "PT1M"
      }
    }

    # Scale IN — CPU < 25%
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_threshold
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = tostring(var.scale_in_count)
        cooldown  = "PT1M"
      }
    }
  }

  predictive {
    scale_mode      = "Enabled"
    look_ahead_time = "PT5M"
  }
}
