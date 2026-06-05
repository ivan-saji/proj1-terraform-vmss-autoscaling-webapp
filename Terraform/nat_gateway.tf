resource "azurerm_nat_gateway" "rg02-vnet01-snet01-natgw01-infra" {
  name                    = local.nat_gateway_name
  location                = local.location
  resource_group_name     = azurerm_resource_group.rg02-infra.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}