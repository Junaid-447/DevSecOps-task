resource "azurerm_subnet" "az_aks_subnet" {
  name                = var.subnet_config["aks"].name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes      = var.subnet_config["aks"].address_prefix
}

resource "azurerm_log_analytics_cluster" "az_log_analytics" {
  name                = concat(var.kubernetes_cluster_name, "-log-analytics") 
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_log_analytics_solution" "az_log_analytics_soln" {
  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.az_log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.az_log_analytics.name
  location              = var.location
  resource_group_name   = var.resource_group_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}

resource "azurerm_kubernetes_cluster" "az_aks" {
    name            = var.kubernetes_cluster_name
    resource_group_name = var.resource_group_name 
    location            = var.location
    kubernetes_version  = var.aks_cluster_version
    dns_prefix          = "devsecops" 
    node_resource_group = var.resource_group_name

    default_node_pool {
      name = concat(var.kubernetes_cluster_name, "-nodepool")
      node_count = var.node_count
      vm_size = var.vm_size
    }

    role_based_access_control_enabled = var.rbac_enabled

    identity {
    type = "SystemAssigned"
  }
    network_profile {
      network_plugin = "azure"
    }
    oms_agent {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.az_log_analytics.id
    }

}