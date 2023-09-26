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
variable "tfstate_resource_group_name" {
  default = "tfstate_test_resource_group"
}
variable "location" {
  default = "East US"
}
variable "tfstate_storage_account_name" {
  default = "tfstate_storage_account_name"
}
variable "tfstate_container" {
  default = "tfstate"
}
variable "tags" {
  default = "tfstate-resource-group"
}
