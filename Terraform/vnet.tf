#Virtual Network
resource "azurerm_virtual_network" "rg02-vnet01-infra" {
  name                = local.vnet_name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = local.vnet_address_space

  tags = {
    environment = local.environment
  }
}

# Public IP for internet connectivity to LB from internet
resource "azurerm_public_ip" "rg02-vnet01-pubip01-infra" {
  name                = "rg02-vnet01-pubip01-infra"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Public IP for NAT Gateway to Internet
resource "azurerm_public_ip" "rg02-vnet01-pubip02-infra" {
  name                = "rg02-vnet01-pubip02-infra"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#define subnet seperately for code flexibility
resource "azurerm_subnet" "rg02-vnet01-snet01-infra" {
  name                 = local.subnet1_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.rg02-vnet01-infra.name
  address_prefixes     = [local.subnet1_address_prefix]
}

#Associate NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "rg02-vnet01-snet01-nsg01-infra" {
  subnet_id                 = azurerm_subnet.rg02-vnet01-snet01-infra.id
  network_security_group_id = azurerm_network_security_group.rg02-vnet01-snet01-nsg01-infra.id
}

#Associate Nat Gateway to Subnet
resource "azurerm_subnet_nat_gateway_association" "rg02-vnet01-snet01-natgw01-infra" {
  subnet_id      = azurerm_subnet.rg02-vnet01-snet01-infra.id
  nat_gateway_id = azurerm_nat_gateway.rg02-vnet01-snet01-natgw01-infra.id
}

#Associate NAT gateway to public IP
resource "azurerm_nat_gateway_public_ip_association" "rg02-vnet01-snet01-natgw01-pubip01-infra" {
  nat_gateway_id    = azurerm_nat_gateway.rg02-vnet01-snet01-natgw01-infra.id
  public_ip_address_id = azurerm_public_ip.rg02-vnet01-pubip02-infra.id
}