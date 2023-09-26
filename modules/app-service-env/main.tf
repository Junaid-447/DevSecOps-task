resource "azurerm_subnet" "az_app_svc_subnet" {
  name                = var.subnet_config["app-svc"].name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes      = var.subnet_config["app-svc"].address_prefix

  delegation {
    name = "Microsoft.Web.hostingEnvironments"
    service_delegation {
      name    = "Microsoft.Web/hostingEnvironments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_app_service_environment_v3" "az_app_svc" {
  name                = var.app_svc_env_name
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.az_app_svc_subnet.id

  internal_load_balancing_mode = "Web"

  cluster_setting {
    name  = "FrontEndSSLCipherSuiteOrder"
    value = "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
  }

  tags = {
    env         = "devsecops"
    terraformed = "true"
  }
}

resource "azurerm_service_plan" "az_app_svc_plan" {
  name                       = concat(var.app_svc_env_name,"-plan")
  resource_group_name        = var.resource_group_name
  location                   = var.location
  os_type                    = var.OS_type
  sku_name                   = "I1v2"
  app_service_environment_id = azurerm_app_service_environment_v3.az_app_svc.id
}

