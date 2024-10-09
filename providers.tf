terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.3"
    }
  }
}

provider "azuredevops" {
  personal_access_token = var.azure_devops_personal_access_token
  org_service_url       = local.org_service_url
}
