
data "local_file" "http_api" {
  filename = "${path.module}/http_api.json"
}

data "local_file" "https_api" {
  filename = "${path.module}/https_api.json"
}

resource "azurerm_subnet" "az_apim_subnet" {
  name                = var.subnet_config["apim"].name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes      = var.subnet_config["apim"].address_prefix
}


resource "azurerm_key_vault" "az_kv" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = false
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
}


resource "azurerm_api_management" "az_apim" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "DevSecOps-Test"
  publisher_email     = "DevSecOps-Email@test.com"
  sku_name            = var.sku_name
  virtual_network_configuration {
    subnet_id = azurerm_subnet.az_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_api_management_api" "az_apim_api" {
  count               = length(var.api_definitions)   
  name                = var.api_definitions[count.index].name
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.az_apim.name
  revision            = "1"
  display_name        = var.api_definitions[count.index].name
  path                = var.api_definitions[count.index].name

  import {
    content_format = "swagger-link-json"
    content_value  = var.api_definitions[count.index].content
  }
}

resource "azurerm_api_management_product" "az_apim_product" {
  product_id            = var.productId
  api_management_name   = var.apim_name
  resource_group_name   = var.resource_group_name
  display_name          = var.productName
  subscription_required = var.subscriptionRequired
  subscriptions_limit   = var.subscriptionsLimit
  approval_required     = var.approvalRequired
  published             = var.published
}
resource "azurerm_api_management_product_policy" "az_apim_product_policy" {
  product_id          = data.azurerm_api_management_product.az_apim_product.product_id
  api_management_name = data.azurerm_api_management_product.az_apim_product.api_management_name
  resource_group_name = data.azurerm_api_management_product.az_apim_product.resource_group_name

  xml_content         = templatefile("${path.module}/policy.xml")
}


resource "azurerm_application_insights" "az_appi" {
  name                = var.appi_name
  resource_group_name = var.resource_group_name
  location            = var.location
  application_type    = "web"
}