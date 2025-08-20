terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id       = "client id"
  client_secret   = "client secret"
  tenant_id       = "tenant id"
  subscription_id = "sub id"
}

provider "azuread" {
  client_id     = "client id"
  client_secret = "client secret"
  tenant_id     = "tenant id"
}
