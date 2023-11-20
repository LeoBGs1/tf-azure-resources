terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.72.0"
    }
  }

  backend "azurerm" {
    resource_group_name   = "."
    storage_account_name   = "."s
    container_name         = "."s
    key                    = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

module "network" {
  source              = "Azure/network/azurerm"
  version             = "4.1.0"
  resource_group_name = var.rg-name
  subnet_names        = ["subnet-leo"]
  subnet_prefixes     = ["10.0.5.0/24"]
}

module "network-security-group" {
  source              = "Azure/network-security-group/azurerm"
  version             = "4.1.0"
  resource_group_name = var.rg-name
  security_group_name = "nsg-leo"
}