#resource group for the entire infrastructure

resource "azurerm_resource_group" "rg02-infra" {
  name     = local.resource_group_name
  location = local.location
}