# Prerequisites
Before using this Terraform code, make sure you have the following prerequisites:

* Terraform installed on your local machine.
* Azure subscription and proper authentication credentials.
* API definitions in JSON format for the API(s) you want to deploy.
* Optional: Azure DevOps pipeline for automated deployment.


# Folder Structure
The folder structure of this Terraform project is organized as follows:

* **main.tf**: The main Terraform configuration file containing resource definitions.
* **variables.tf**: Variables and their descriptions, which can be customized.
* **outputs.tf**: Output variables that provide information after provisioning.
* **modules**: This folder defines all the modules that are created
* **policy.xml**: An example policy file used for API management product policies.
* **versions.tf**: This file holds the details for dependencies versions
* **README.md**: This documentation file.

# Variables
Customize the variables in the **'variables.tf'** file to configure the deployment according to your requirements. The variables include details about API definitions, Azure resources, and more.

# Terraform Configuration
In the **main.tf** file, you will find the Terraform configuration for provisioning Azure resources. This configuration includes the definition of resources like API management, virtual networks, key vaults, and more.

# Terraform Modules
This Terraform project does not use modules but follows a straightforward structure. However, for larger and more complex projects, consider modularizing your code to improve maintainability and reusability.