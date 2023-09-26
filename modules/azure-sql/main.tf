resource "azurerm_subnet" "az_sql_subnet" {
  name                = var.subnet_config["sql"].name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes      = var.subnet_config["sql"].address_prefix

  delegation {
    name = var.delegation_name
  }
  service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
}

resource "azurerm_network_security_group" "az_nsg" {
  name                = concat(var.sql_name,"-nsg")
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_network_security_rule" "az_nsg_rule_app_svc" {
  name                        = "allow-app-service-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*" 
  source_address_prefix       = "10.0.4.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.az_nsg.name
}
resource "azurerm_network_security_rule" "az_nsg_rule_aks_svc" {
  name                        = "allow-aks-cluster-inbound"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*" 
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.az_nsg.name
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny_all_inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.az_nsg.name
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  name                        = "deny_all_outbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.az_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "az_subnet_nsg" {
  network_security_group_id = azurerm_network_security_group.az_nsg.id
  subnet_id = azurerm_subnet.az_sql_subnet.id
}

resource "azurerm_sql_managed_instance" "az_sql_mi" {
  name = var.sql_name
  resource_group_name = var.resource_group_name
  location = var.location
  administrator_login = var.administrator_login
  administrator_login_password = var.administrator_login_password
  license_type = var.license_type
  subnet_id = azurerm_subnet.az_sql_subnet.id
  sku_name = var.sql_sku_name
  vcores = var.vcores
  storage_size_in_gb = var.storage

  depends_on = [azurerm_subnet_network_security_group_association.az_subnet_nsg]
}