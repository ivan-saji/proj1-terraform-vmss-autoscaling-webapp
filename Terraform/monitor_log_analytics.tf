resource "azurerm_log_analytics_workspace" "law01" {
    name                = "law01"
    location            = azurerm_resource_group.rg02-infra.location
    resource_group_name = azurerm_resource_group.rg02-infra.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
}