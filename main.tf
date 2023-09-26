module "az-base" {
   source = "./modules/az-base"
   tfstate_resource_group_name = var.tfstate_resource_group_name
   tfstate_storage_account_name = var.tfstate_storage_account_name
   tfstate_container = var.tfstate_container
}

module "tfmod-az-resource-group"{
    source                  = "./modules/resource-group"
    resource_group_name     = var.resource_group_name
    location                = var.location    
    depends_on              = [ module.az-base ]            
}
module "tfmod-az-virtual-network"{
    source                  = "./modules/virtual-network"
    vnet_name               = var.vnet_name
    address_space           = var.address_space
    resource_group_name     = module.tfmod-az-resource-group.resource_group_name
    location                = module.tfmod-az-resource-group.resource_group_location                 
    depends_on              = [ module.az-base, module.tfmod-az-resource-group ] 
}
module "tfmod-az-apim" {
    source                  = "./modules/api-management"
    apim_name               = var.apim_name
    sku_name                = var.sku_name
    vnet_name               = module.tfmod-az-virtual-network.virtual_network_name
    depends_on              = [ module.az-base, module.tfmod-az-resource-group, module.tfmod-az-virtual-network ]
}
module "tfmod-az-appgw" {
    source                  = "./modules/application-gateway"
    apim_name               = var.apim_name
    sku_name                = var.sku_name
    vnet_name               = module.tfmod-az-virtual-network.virtual_network_name
    apim_private_ip_address = module.tfmod-az-apim.api_management_private_ip_address
    resource_group_name     = module.tfmod-az-resource-group.resource_group_name
    location                = module.tfmod-az-resource-group.resource_group_location
    depends_on              = [ module.az-base, module.tfmod-az-resource-group, module.tfmod-az-virtual-network, module.tfmod-az-apim ]
}

module "tfmod-az-aks" {
    source                  = "./modules/azure-k8s"
    aks_cluster_version     = var.aks_cluster_version
    kubernetes_cluster_name = var.kubernetes_cluster_name
    node_count              = var.node_count
    rbac_enabled            = var.rbac_enabled 
    vnet_name               = module.tfmod-az-virtual-network.virtual_network_name
    resource_group_name     = module.tfmod-az-resource-group.resource_group_name
    location                = module.tfmod-az-resource-group.resource_group_location
    depends_on              = [ module.az-base, module.tfmod-az-resource-group, module.tfmod-az-virtual-network ]
}

module "tfmod-az-sql-mi" {
    source                       = "./modules/azure-sql"
    sql_name                     = var.sql_name
    administrator_login          = var.administrator_login
    administrator_login_password = var.administrator_login_password
    license_type                 = var.license_type
    sql_sku_name                 = var.sql_sku_name
    vcores                       = var.vcores
    storage_size_in_gb           = var.storage_size_in_gb
    vnet_name                    = module.tfmod-az-virtual-network.virtual_network_name
    resource_group_name          = module.tfmod-az-resource-group.resource_group_name
    location                     = module.tfmod-az-resource-group.resource_group_location
    depends_on                   = [ module.az-base, module.tfmod-az-resource-group, module.tfmod-az-virtual-network, module.tfmod-az-aks, module.app-service ]
}
module "tfmod-app-svc-env" {
    source                       = "./modules/app-service-env"
    app_svc_env_name             = var.app_svc_env_name
    OS_type                      = var.OS_type
    vnet_name                    = module.tfmod-az-virtual-network.virtual_network_name
    resource_group_name          = module.tfmod-az-resource-group.resource_group_name
    location                     = module.tfmod-az-resource-group.resource_group_location
    depends_on                   = [ module.az-base, module.tfmod-az-resource-group, module.tfmod-az-virtual-network, module.tfmod-az-aks, module.tfmod-az-apim ]
}