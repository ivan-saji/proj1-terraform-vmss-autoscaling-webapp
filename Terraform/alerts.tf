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

resource "azurerm_monitor_metric_alert" "cpu_alert_95" {
  name                = "cpu_alert_95"
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
resource "azurerm_monitor_metric_alert" "cpu_alert_80" {
  name                = "cpu_alert_80"
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
/*
Commenting memory rules for now as there is an issue with the query and it is not working as expected. Will investigate and update the code later.
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "memory_warning_80" {

  name                = "vmss_memory_warning_80"
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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "memory_warning_95" {

  name                = "vmss_memory_warning_95"
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

*/

# Heartbeat Alert Rule
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "vmss_heartbeat" {

  name                = "vmss-heartbeat"
  location            = azurerm_resource_group.rg03-monitoring.location
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  description         = "Action will be triggered when there is no heartbeat from VMSS for 10 minutes."

  evaluation_frequency = "PT5M"
  window_duration      = "PT10M"

  scopes = [
    azurerm_log_analytics_workspace.law01.id
  ]

  severity = 0

  criteria {

    query = <<QUERY
      Heartbeat
      | summarize LastHeartbeat=max(TimeGenerated) by Computer
      | where LastHeartbeat < ago(5m)
      QUERY

    operator  = "GreaterThan"
    threshold = 0

    time_aggregation_method = "Count"

  }

  action {
    action_groups = [
      azurerm_monitor_action_group.email_alerts.id
    ]
  }

}

#Autoscale Alert Rule
resource "azurerm_monitor_activity_log_alert" "autoscale_alert" {
  name                = "vmss-autoscale-alert"
  location            = azurerm_resource_group.rg03-monitoring.location
  resource_group_name = azurerm_resource_group.rg03-monitoring.name
  scopes              = [azurerm_linux_virtual_machine_scale_set.vmss01.id]

  description         = "Action will be triggered when autoscale action is performed on VMSS."

  criteria {
    category = "Autoscale"
    operation_name = "Microsoft.Insights/autoscaleSettings/scale"
    status = "Succeeded"
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alerts.id
  }
}