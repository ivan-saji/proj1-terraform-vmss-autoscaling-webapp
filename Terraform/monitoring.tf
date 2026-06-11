#Log Analytics Workspace for VMSS
resource "azurerm_log_analytics_workspace" "law01" {
    name                = "law01"
    location            = azurerm_resource_group.rg03-monitoring.location
    resource_group_name = azurerm_resource_group.rg03-monitoring.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
}

#DCR for VMSS
resource "azurerm_monitor_data_collection_rule" "vmss_dcr01" {
    name                = "vmss_dcr01"
    location            = azurerm_resource_group.rg03-monitoring.location
    resource_group_name = azurerm_resource_group.rg03-monitoring.name

    #Destination where data needs to be sent.
    destinations {
        log_analytics {
            workspace_resource_id = azurerm_log_analytics_workspace.law01.id
            name                  = "law01"
        }
    }

    #Define what data needs to be collected and where it needs to be sent.
    data_flow {
        streams = ["Microsoft-Perf", "Microsoft-Syslog"]
        destinations = ["law01"]
    }

    #Define what all data needs to be collected.
    data_sources {
        performance_counter {
            name    = "cpu-memory"
            streams = ["Microsoft-Perf"]

            sampling_frequency_in_seconds = 60

            counter_specifiers = [
                "\\Processor(_Total)\\% Processor Time",
                "\\Memory\\Available MBytes",
            ]
        }

        syslog {
            name           = "linux-syslog"
            streams        = ["Microsoft-Syslog"]
            facility_names = ["*"]
            log_levels     = ["*"]
        }
    }

}