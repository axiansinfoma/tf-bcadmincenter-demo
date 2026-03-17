resource "azurerm_resource_group" "example" {
  name     = "rg-demo-prd-example"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "law-demo-prd-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "example" {
  name                = "appi-demo-prd-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.example.id
}
