resource "azurerm_log_analytics_workspace" "law01" {
    name                = "law01"
    location            = azurerm_resource_group.rg01.location
    resource_group_name = azurerm_resource_group.rg01.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
}