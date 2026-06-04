resource "azurerm_nat_gateway" "rg02-vnet01-snet01-natgw01-infra" {
  name                    = local.nat_gateway_name
  location                = local.location
  resource_group_name     = local.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}