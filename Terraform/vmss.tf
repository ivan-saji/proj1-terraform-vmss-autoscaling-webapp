#VMSS Linux Script
resource "azurerm_linux_virtual_machine_scale_set" "vmss01" {

  name                = local.vmss_name
  resource_group_name = local.resource_group_name
  location            = local.location

  sku       = "Standard_B1ms"
  instances = local.vmss_default_capacity

  admin_username = "adminuser"

  disable_password_authentication = false
  admin_password                  = "testvmss123"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    disk_size_gb         = 30
  }

  network_interface {

    name    = "${local.vmss_name}-nic"
    primary = true

    ip_configuration {

      name    = "internal"
      primary = true

      subnet_id = azurerm_subnet.rg02-vnet01-snet01-infra.id

      load_balancer_backend_address_pool_ids = [
      azurerm_lb_backend_address_pool.rg02-vnet01-lb01-backendpool01-infra.id
    ]

    }
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }

}

#Autoscale Setting for VMSS

resource "azurerm_monitor_autoscale_setting" "vmss_autoscale" {

  name                = "${local.vmss_name}-autoscale"
  resource_group_name = local.resource_group_name
  location            = local.location

  target_resource_id = azurerm_linux_virtual_machine_scale_set.vmss01.id

  profile {

    name = "default"
    #Default capacity settings for the VMSS
    capacity {
      default = local.vmss_default_capacity
      minimum = local.vmss_minimum_capacity
      maximum = local.vmss_maximum_capacity
    }

    # Scale Out

    rule {

      metric_trigger {

        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss01.id

        time_grain       = "PT1M"
        time_window      = "PT5M"
        statistic        = "Average"
        time_aggregation = "Average"

        operator  = "GreaterThan"
        threshold = 80
      }

      scale_action {

        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"

        cooldown = "PT5M"
      }
    }

    # Scale In

    rule {

      metric_trigger {

        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss01.id

        time_grain       = "PT1M"
        time_window      = "PT5M"
        statistic        = "Average"
        time_aggregation = "Average"

        operator  = "LessThan"
        threshold = 10
      }

      scale_action {

        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"

        cooldown = "PT5M"
      }
    }
  }
}