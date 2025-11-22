terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.50.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "shrutibackend01"                        # Example: "rg-backend"
    storage_account_name = "shruti01storage01ac01"                      # Example: "rgbackendtorageaccount"
    container_name       = "shrutistorage01container01"             # Example: "rgbackendstoragecontainer"
    key                  = "Project03.terraform.tfstate"
  }

  required_version = ">= 1.0.0"
}
