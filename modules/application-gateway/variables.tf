# variable "client_id" {}
# variable "client_secret" {}

# variable "subscription_id" {
#   description = "Azure subscription id"
#   default     = "0000000-0000-0000-0000-000000000000"
# }

# variable "tenant_id" {
#   description = "Azure tenant id"
#   default     = "0000000-0000-0000-0000-000000000000"
# }
variable "vnet_name" {
  default = "devsecops-vnet"
}
variable "address_space" {
  default = ["10.1.0.0/24"]
}
variable "resource_group_name" {
  default = "default-resource-group"
}
variable "location" {
  default = "East US"
}
variable "subnet_config" {
  type = map(object({
    name          = string
    address_prefix = list(string)
  }))
  description = "Configuration for APIM subnet"
  default = {
    app_gw = {
      name           = "appgw-subnet"
      address_prefix = ["10.10.1.0/24"]
    }
  }
}
variable "apim_name" {
  default = "apimdevsecops"
}
variable "sku_name" {
  default = "Developer_1"
}

variable "apim_private_ip_address" {
}

variable "pip_name" {
  default = "appgw_pip"
}

variable "allocation_method" {
  default = "Dynamic"
}

variable "waf_name" {
  default = "WAF_v2"
}

variable "waf_sku" {
  default = "WAF_v2"
}

variable "waf_capacity" {
  default = 1
}

variable "protocol" {
  default = "Http"
}
variable "backend_address_pool_name" {
  default = "apim-backend-pool"
}

variable "backend_http_settings_name" {
  default = "backend-http-settings"
}
variable "gateway_ip_configuration_name" {
  default = "appgw-ip-configuration"
}
variable "listener" {
  default = "http-listener"
}
variable "frontend_port_name" {
  default = "http-port"
}

variable "port" {
  default = 8080
}

variable "probe" {
  default = "http-probe"
}
variable "cert_name" {
  name = "DevSecOpsCertificate"
}
variable "tags" {
tags = {
    ProjectName  = "demo-internal"
    Env          = "Terraform-IaC-dev"
    Owner        = "user@example.com"
  }
}