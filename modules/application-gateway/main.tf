locals {
  api_management_private_ipaddr = var.apim_private_ip_address
}

resource "azurerm_subnet" "az_appgw_subnet" {
  name                = var.subnet_config["app_gw"].name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes      = var.subnet_config["app_gw"].address_prefix
}

resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
}

resource "azurerm_application_gateway" "az_appgw" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.waf_name
    tier     = var.waf_sku
    capacity = var.waf_capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = azurerm_subnet.az_appgw_subnet.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.port
  }

  frontend_ip_configuration {
    name = var.gateway_ip_configuration_name
    public_ip_address_id = null
    subnet_id = azurerm_subnet.az_appgw_subnet.id
  }

  http_listener {
    name                           = var.listener
    frontend_ip_configuration_name = var.gateway_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = var.protocol
    ssl_certificate_name           = var.cert_name
  }

  backend_address_pool {
    name = var.backend_address_pool_name
    backend_addresses {
      fqdns = [locals.api_management_private_ipaddr]
    }

  }

  probe {
    name               = var.probe
    protocol           = var.protocol
    host               = locals.api_management_private_ipaddr
    path               = "/"
    interval           = "30"
    unhealthy_threshold = "3"
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = var.listener
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.backend_http_settings_name
  }

  backend_http_settings {
    name                  = var.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = var.port
    protocol              = var.protocol
    request_timeout       = 60
    probe_name            = var.probe
  }

  url_path_map {
      name                               = "internal-url"
      default_backend_address_pool_name  = var.backend_address_pool_name
      default_backend_http_settings_name = var.backend_http_settings_name
      path_rules = [
        {
          name                       = "external"
          paths                      = ["/internal/api2"]
          backend_address_pool_name  = var.backend_address_pool_name
          backend_http_settings_name = var.backend_http_settings_name
        } 
      ]
    }

}
