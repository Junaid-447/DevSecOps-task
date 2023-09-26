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
    aks = {
      name           = "aks-subnet"
      address_prefix = ["10.10.2.0/24"]
    }
  }
}
variable "kubernetes_cluster_name" {
  default = "dev-aks-cluster"
}
variable "aks_cluster_version" {
  default = "1.24.0"
}

variable "node_count" {
  default = 3
}
variable "rbac_enabled" {
  type = bool
  default = true
}
variable "tags" {
tags = {
    ProjectName  = "demo-internal"
    Env          = "Terraform-IaC-dev"
    Owner        = "user@example.com"
  }
}