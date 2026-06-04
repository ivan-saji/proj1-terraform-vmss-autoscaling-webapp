locals {
  #Infra location
  location = "West Europe"

  #Infra Environment
  environment = "Production"

  #Infra Resource Group name
  resource_group_name = "rg02-infra"

  #Vnet Details
  vnet_name          = "rg02-vnet01-infra"
  vnet_address_space = ["10.0.0.0/16"]

  #Subnet Details
  subnet1_name           = "rg02-vnet01-snet01-infra"
  subnet1_address_prefix = "10.0.1.0/24"

  #Subnet1 NSG1 Details
  subnet1_nsg_name = "rg02-vnet01-snet01-nsg01-infra"

  nsg01_security_rules = {
    allow_http_inbound = {
      priority  = 110
      port      = 80
      direction = "Inbound"
      access    = "Allow"
    }

    allow_https_inbound = {
      priority  = 120
      port      = 443
      direction = "Inbound"
      access    = "Allow"
    }

    allow_http_outbound = {
      priority  = 110
      port      = 80
      direction = "Outbound"
      access    = "Allow"
    }

    allow_https_outbound = {
      priority  = 120
      port      = 443
      direction = "Outbound"
      access    = "Allow"
    }

    allow_ssh_inbound = {
      priority  = 130
      port      = 22
      direction = "Inbound"
      access    = "Allow"

    }

    allow_lb_health_probe_inbound = {
      priority  = 100
      port      = 80
      direction = "Inbound"
      access    = "Allow"
      source    = "AzureLoadBalancer"
    }
  }

  #Nat Gateway Details
  nat_gateway_name = "rg02-vnet01-snet01-natgw01-infra"

  #VMSS Details
  vmss_name = "rg02-vmss01-infra"
  vmss_default_capacity = 2
  vmss_minimum_capacity = 1
  vmss_maximum_capacity = 5

}
