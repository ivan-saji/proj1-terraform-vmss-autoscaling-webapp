#action group for mail alerts
resource "azurerm_monitor_action_group" "email_alerts" {
  name                = "vmss-email-alerts"
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  short_name          = "emailAlerts"

  email_receiver {
    name          = "VMSS Alert"
    email_address = local.alert_mail_to
    use_common_alert_schema = true
  }
}