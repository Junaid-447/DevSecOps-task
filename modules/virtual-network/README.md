# Prerequisites
Before using this Terraform code, ensure you have the following prerequisites:

* [Terraform](https://developer.hashicorp.com/terraform/downloads) installed on your local machine.
* An Azure subscription and the necessary authentication credentials.
* Customization of variables in the **variables.tf** file to match your environment.

# Folder Structure
The folder structure of this Terraform project is organized as follows:

* **main.tf**: The main Terraform configuration file containing resource definitions for the resource group, storage account, and storage container.
* **variables.tf**: Variables and their descriptions, which can be customized to configure the state backend.
* **outputs.tf**: Output variables that provide information about the provisioned Azure resources.
* **README.md**: This documentation file.

# Variables
Customize the variables in the code snippet according to your requirements. In this code snippet, the variables include:

* **var.vnet_name**: The name of the Azure Virtual Network to create.
* **var.address_space**: The address space for the Virtual Network.
* **var.resource_group_name**: The name of the Azure Resource Group where the Virtual Network should be created.
* **var.location**: The Azure region where the Virtual Network should be located.
* **var.tags**: Tags to associate with the Virtual Network and DDoS Protection Plan (optional).
You can modify these variables to suit your naming conventions and requirements.

# Terraform Configuration
This code snippet defines two resources:

* **azurerm_virtual_network** resource block: It specifies the name, address space, location, and tags for the Azure Virtual Network based on the provided variables.

* **azurerm_network_ddos_protection_plan** resource block: It specifies the name, location, and resource group name for the DDoS Protection Plan. The location and resource group name are derived from the associated Virtual Network.