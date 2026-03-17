# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.64.0"
    }
    bcadmincenter = {
      source  = "axiansinfoma/bcadmincenter"
      version = "0.1.5"
    }
  }
  required_version = "1.14.7"

  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

provider "bcadmincenter" {
}
