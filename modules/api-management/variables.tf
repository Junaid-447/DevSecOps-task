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
    apim = {
      name           = "apim-subnet"
      address_prefix = ["10.10.0.0/24"]
    }
  }
}
variable "apim_name" {
  default = "apimdevsecops"
}
variable "sku_name" {
  default = "Developer"
}

variable "api_definitions" {
  description = "List of API definitions to import"
  type        = list(object({
    name    = string
    content = string
  }))
  default = [
    {
      name    = "internal-api"
      content = data.local_file.http_api.content
    },
    {
      name    = "external-api"
      content = data.local_file.https_api.content
    }
  ]
}
variable "productId" {
  default = "devsecops"
}
variable "display_name" {
  default = "DevSecOps-Product"
}
variable "subscription_required" {
  type = bool
  default = true
}
variable "subscriptionLimit" {
  default = 25
}
variable "approval_required" {
  type = bool
  default = true
}
variable "published" {
  type = bool
  default = true
}
variable "xml_content"{
  type = string
}
variable "tags" {
  default = "Terraform-IaC-dev-virtual-network"
}