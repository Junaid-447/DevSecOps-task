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
    app-svc = {
      name           = "app-svc-subnet"
      address_prefix = ["10.10.4.0/24"]
    }
  }
}

variable "app_svc_env_name" {
  default = "devsecops-app-svc-name"
}

variable "OS_type" {
  default = "Linux"
}

variable "tags" {
tags = {
    ProjectName  = "demo-internal"
    Env          = "Terraform-IaC-dev"
    Owner        = "user@example.com"
  }
}