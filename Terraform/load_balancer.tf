# Load Balancer
resource "azurerm_lb" "rg02-vnet01-lb01-infra" {
  name                = "rg02-vnet01-lb01-infra"
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.rg02-vnet01-pubip01-infra.id
  }
}

# Load Balancer Backend Address Pool

resource "azurerm_lb_backend_address_pool" "rg02-vnet01-lb01-backendpool01-infra" {

  name            = "rg02-vnet01-lb01-backendpool01-infra"
  loadbalancer_id = azurerm_lb.rg02-vnet01-lb01-infra.id

}

# Load Balancer Health Probe
resource "azurerm_lb_probe" "rg02-vnet01-lb01-healthprobe01-infra" {
  name            = "rg02-vnet01-lb01-healthprobe01-infra"
  loadbalancer_id = azurerm_lb.rg02-vnet01-lb01-infra.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# Load Balancer Rule Front end 80 to Back end 80
resource "azurerm_lb_rule" "rg02-vnet01-lb01-lbrule01-infra" {
  name                           = "http_rule"
  loadbalancer_id                = azurerm_lb.rg02-vnet01-lb01-infra.id
  protocol                        = "Tcp"
  frontend_port                   = 80
  backend_port                    = 80
  frontend_ip_configuration_name = "PublicIPAddress"

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.rg02-vnet01-lb01-backendpool01-infra.id
  ]

  probe_id                        = azurerm_lb_probe.rg02-vnet01-lb01-healthprobe01-infra.id
} 