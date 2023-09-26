variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}

variable "tfstate_resource_group_name" {
  default = "tfstate_resource_group_name"
}

variable "tfstate_storage_account_name" {
  default = "tfstatedevsecops919"
}
variable "tfstate_container" {
  default = "tfstate"
}

variable "resource_group_name" {
  default = "test-resource-group"
  description = "Resource group name"
}
variable "location" {
  default = "East US"
  description = "Location for resource group"
}
variable "vnet_name" {
  default = "devsecops-test-vnet"
  description = "Name for the Virtual Network"
}
variable "address_space" {
  default = ["10.14.0.0/16"]
  description = "Address Space for the virtual network"
}

variable "apim_name" {
  default = "devsecopsapim"
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
    local.http_api_definition,
    local.https_api_definition,
  ]
}

variable "kubernetes_cluster_name" {
  default = "dev-sec-ops-k8s-cluster"
}

variable "aks_cluster_version" {
  default = "1.25.6"  
}

variable "node_count" {
  default = 3
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

variable "app_svc_env_name" {
  default = "devsecops-app-svc-name"
}

variable "OS_type" {
  default = "Linux"
}

variable "tags" {
  default = "Terraform-IaC"
}
