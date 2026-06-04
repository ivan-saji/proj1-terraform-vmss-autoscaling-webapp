resource "azurerm_network_security_group" "rg02-vnet01-snet01-nsg01-infra" {
  name                = local.subnet1_nsg_name
  location            = local.location
  resource_group_name = local.resource_group_name
  tags = {
    environment = local.environment
  }

  #Using Dynamic block to create security rules

    dynamic "security_rule" {
        for_each = local.nsg01_security_rules
    
        content {
        name                       = security_rule.key
        priority                   = security_rule.value.priority
        direction                  = security_rule.value.direction
        access                     = security_rule.value.access
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = security_rule.value.port

        #Later update with Load Balancer and Application Gateway IPs
        source_address_prefix      = security_rule.key == "allow_lb_health_probe_inbound" ? "AzureLoadBalancer" : "*"

        destination_address_prefix = "*"
        }
    }
}