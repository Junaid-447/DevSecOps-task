
# Prerequisites
Before using this Terraform code, make sure you have the following prerequisites:

* Terraform installed on your local machine.
* Azure subscription and proper authentication credentials.
* Optional: Azure DevOps pipeline for automated deployment.


# Usage

To run provision the environment use below commands to start
Below metioned command will initialize the terraform instance, locking the version of providers

 ```bash
 terraform init
 ```

To check the changes that will be made by the terraform modules use below command

```bash
terraform plan '-var client_id -var client_secret -var subscription_id -var tenant_id'
```
And finally if everything seems right run the below command to apply the changes

```bash
terraform apply '-var client_id -var client_secret -var subscription_id -var tenant_id'
```

In any situation if you have to demolish/destroy the infrastructure. Please execute the below command

```bash
terraform plan -destroy '-var client_id -var client_secret -var subscription_id -var tenant_id'
terraform destroy '-var client_id -var client_secret -var subscription_id -var tenant_id'
```


# Folder Structure
The folder structure of this Terraform project is organized as follows:

* main.tf: The main Terraform configuration file containing resource definitions.
* variables.tf: Variables and their descriptions, which can be customized.
* outputs.tf: Output variables that provide information after provisioning.
* modules: This folder defines all the modules that are created
* versions.tf: This file holds the details for dependencies versions
* README.md: This documentation file.

# Terraform Modules
Each module has a specific task which is defined below

## az-base Module
This module represents the base infrastructure for the project. It sets up the Terraform state storage and resource group for the project.

### Usage

```hcl
module "az-base" {
   source = "./modules/az-base"
   tfstate_resource_group_name = var.tfstate_resource_group_name
   tfstate_storage_account_name = var.tfstate_storage_account_name
   tfstate_container = var.tfstate_container
}
```

### Inputs

- tfstate_resource_group_name
 (required): The name of the resource group where the Terraform state will be stored. </br>

- tfstate_storage_account_name
 (required): The name of the storage account where the Terraform state will be stored. </br>

- tfstate_container
 (required): The name of the container within the storage account where the Terraform state will be stored. </br>

## tfmod-az-resource-group Module
This module creates an Azure resource group for the project

### Usage

```hcl
module "tfmod-az-resource-group"{
    source                  = "./modules/resource-group"
    resource_group_name     = var.resource_group_name
    location                = var.location    
    depends_on              = [ module.az-base ]            
}
```

### Inputs

- resource_group_name(required): The name of the Azure resource group </br>

- location(required): The location where the resource group will be created </br>

## tfmod-az-virtual-network Module
This module creates an Azure virtual network.

### Usage

```hcl
module "tfmod-az-virtual-network"{
    source                  = "./modules/virtual-network"
    vnet_name               = var.vnet_name
    address_space           = var.address_space
    resource_group_name     = module.tfmod-az-resource-group.resource_group_name
    location                = module.tfmod-az-resource-group.resource_group_location                 
    depends_on              = [ module.az-base, module.tfmod-az-resource-group ] 
}
```

### Inputs

- vnet_name
 (required): The name of the Azure virtual network.

- address_space
 (required): The address space for the virtual network.

- resource_group_name
 (required): The name of the resource group where the virtual network will be created.

- location
 (required): The location where the virtual network will be created.

## tfmod-az-apim Module
This module creates an Azure API Management service.

### Usage

```hcl
module "tfmod-az-apim" {
    source                  = "./modules/api-management"
    apim_name               = var.apim_name
    sku_name                = var.sku_name
    vnet_name               = module.tfmod-az-virtual-network.virtual_network_name
    depends_on              = [ module.az-base, module.tfmod-az-resource-group, module.tfmod-az-virtual-network ]
}
```

### Inputs

- apim_name
 (required): The name of the Azure API Management service.

- sku_name
 (required): The SKU (size) of the API Management service.

- vnet_name
 (required): The name of the virtual network to which the API Management service will be connected.

## tfmod-az-appgw Module
This module creates an Azure Application Gateway.

### Usage

```hcl
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
```

### Inputs

- apim_name
(required): The name of the Azure API Management service.

- sku_name
 (required): The SKU (size) of the Application Gateway.

- vnet_name
 (required): The name of the virtual network to which the Application Gateway will be connected.

- apim_private_ip_address
 (required): The private IP address of the API Management service.

- resource_group_name
 (required): The name of the resource group where the Application Gateway will be created.

- location
 (required): The location where the Application Gateway will be created.

## tfmod-az-aks Module
This module creates an Azure Kubernetes Service (AKS) cluster.

### Usage

```hcl
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
```

### Inputs

- aks_cluster_version
 (required): The version of the AKS cluster.

- kubernetes_cluster_name
 (required): The name of the AKS cluster.

- node_count
 (required): The number of nodes in the AKS cluster.

- rbac_enabled
 (required): Whether RBAC (Role-Based Access Control) is enabled for the AKS cluster.

- vnet_name
 (required): The name of the virtual network in which the AKS cluster will be created.

- resource_group_name
 (required): The name of the resource group where the AKS cluster will be created.

- location
 (required): The location where the AKS cluster will be created.

## tfmod-az-sql-mi Module
This module creates an Azure SQL Managed Instance.

### Usage

```hcl
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
```

### Inputs
- sql_name
 (required): The name of the Azure SQL Managed Instance.

- administrator_login
 (required): The login username for the SQL Managed Instance.

- administrator_login_password
 (required): The login password for the SQL Managed Instance.

- license_type
 (required): The license type for the SQL Managed Instance.

- sql_sku_name
 (required): The SKU (size) of the SQL Managed Instance.

- vcores
 (required): The number of virtual cores for the SQL Managed Instance.

- storage_size_in_gb
 (required): The storage size in GB for the SQL Managed Instance.

- vnet_name
 (required): The name of the virtual network in which the SQL Managed Instance will be created.

- resource_group_name
 (required): The name of the resource group where the SQL Managed Instance will be created.

- location
 (required): The location where the SQL Managed Instance will be created.

## tfmod-app-svc-env Module
This module creates an Azure App Service Environment.

### Usage

```hcl
module "tfmod-app-svc-env" {
    source                       = "./modules/app-service-env"
    app_svc_env_name             = var.app_svc_env_name
    OS_type                      = var.OS_type
    vnet_name                    = module.tfmod-az-virtual-network.virtual_network_name
}
```

### Inputs
- app_svc_env_name
 (required): The name of the Azure App Service Environment.

- OS_type
 (required): The operating system type for the App Service Environment.

- vnet_name
 (required): The name of the virtual network in which the App Service Environment will be created.

</br>
