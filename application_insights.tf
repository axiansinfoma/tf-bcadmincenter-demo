data "azurerm_resource_group" "appi" {
  name = "rg-bc-demo-mivi"
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-bc-demo-mivi"
  location            = data.azurerm_resource_group.appi.location
  resource_group_name = data.azurerm_resource_group.appi.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "appi" {
  name                = "appi-bc-demo-mivi"
  location            = data.azurerm_resource_group.appi.location
  resource_group_name = data.azurerm_resource_group.appi.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id
}