#action group for mail alerts
resource "azurerm_monitor_action_group" "email_alerts" {
  name                = "vmss-email-alerts"
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  short_name          = "emailAlerts"

  email_receiver {
    name                    = "VMSS Alert"
    email_address           = local.alert_mail_to
    use_common_alert_schema = true
  }
}

#CPU Alert Rules

resource "azurerm_monitor_metric_alert" "cpu-alert-95" {
  name                = "cpu-alert-95"
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  scopes              = [azurerm_linux_virtual_machine_scale_set.vmss01.id]
  description         = "Action will be triggered when CPU usage is greater than 95%."

  frequency   = "PT1M"
  severity    = 0
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = local.alert_thresholds.cpu_critical
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
}
resource "azurerm_monitor_metric_alert" "cpu-alert-80" {
  name                = "cpu-alert-80"
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  scopes              = [azurerm_linux_virtual_machine_scale_set.vmss01.id]
  description         = "Action will be triggered when CPU usage is greater than 80%."

  frequency   = "PT1M"
  severity    = 2
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = local.alert_thresholds.cpu_warning
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
}

#Memory Alert Rules

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "memory_warning-80" {

  name                = "vmss-memory-warning-80"
  location            = azurerm_resource_group.rg03-monitoring.location
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  description         = "Action will be triggered when Memory usage is greater than 80%."

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  scopes = [
    azurerm_log_analytics_workspace.law01.id
  ]

  severity = 2

  criteria {

    query = <<QUERY
Perf
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by bin(TimeGenerated, 5m)
QUERY

    operator  = "GreaterThan"
    threshold = local.alert_thresholds.memory_warning

    time_aggregation_method = "Average"

  }

  action {
    action_groups = [
      azurerm_monitor_action_group.email_alerts.id
    ]
  }

}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "memory_warning-95" {

  name                = "vmss-memory-warning-95"
  location            = azurerm_resource_group.rg03-monitoring.location
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  description         = "Action will be triggered when Memory usage is greater than 95%."

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"

  scopes = [
    azurerm_log_analytics_workspace.law01.id
  ]

  severity = 0

  criteria {

    query = <<QUERY
Perf
| where CounterName == "% Committed Bytes In Use"
| summarize AvgMemory = avg(CounterValue) by bin(TimeGenerated, 5m)
QUERY

    operator  = "GreaterThan"
    threshold = local.alert_thresholds.memory_critical

    time_aggregation_method = "Average"

  }

  action {
    action_groups = [
      azurerm_monitor_action_group.email_alerts.id
    ]
  }

}