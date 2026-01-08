# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.48.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    bcadmincenter = {
      source  = "vllni/bcadmincenter"
      version = "0.0.1"
    }
  }
  required_version = "1.14.3"
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# get the tenant id from the currently authenticated AzureRM client
data "azurerm_client_config" "current" {}

provider "bcadmincenter" {
  tenant_id = data.azurerm_client_config.current.tenant_id
}