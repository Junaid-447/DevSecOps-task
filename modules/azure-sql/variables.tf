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
    sql = {
      name           = "sql-subnet"
      address_prefix = ["10.10.3.0/24"]
    }
  }
}
variable "delegation_name" {
  default = "sql-delegation"
}

variable "sql_name" {
  default = "devsecops-sql"
}

variable "administrator_login" {
  default = "dev-user"
}

#Add it on the Azure DevOps variable group
variable "administrator_login_password" {
}

variable "license_type" {
  default="BasePrice"
}

variable "sql_sku_name" {
  default = "GP_Gen5"
}

variable "vcores" {
  default = 4
}

variable "storage_size_in_gb" {
  default = 32
}


variable "tags" {
tags = {
    ProjectName  = "demo-internal"
    Env          = "Terraform-IaC-dev"
    Owner        = "user@example.com"
  }
}