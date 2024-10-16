data "azuredevops_project" "project" {
  name = var.azure_devops_project_name
}

data "azuredevops_git_repository" "repo" {
  project_id = data.azuredevops_project.project.id
  name       = var.azure_devops_project_name
}

locals {
  org_service_url = "https://dev.azure.com/${var.azure_devops_organization_name}"
}

resource "azuredevops_variable_group" "terraform" {
  project_id   = data.azuredevops_project.project.id
  name         = var.azure_devops_variable_group_name
  description  = "Variables for the Terraform backend"
  allow_access = true

  variable {
    name  = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
    value = azurerm_resource_group.terraform.name
  }

  variable {
    name  = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
    value = azurerm_storage_account.terraform.name
  }

  variable {
    name  = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
    value = azurerm_storage_container.terraform.name
  }
}

resource "azuredevops_serviceendpoint_azurerm" "terraform" {
  project_id                             = data.azuredevops_project.project.id
  service_endpoint_name                  = var.azure_devops_service_connection_name
  description                            = "Generated by Terraform"
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"

  credentials {
    serviceprincipalid = azurerm_user_assigned_identity.terraform.client_id
  }

  azurerm_spn_tenantid      = data.azurerm_subscription.terraform.tenant_id
  azurerm_subscription_id   = var.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.terraform.display_name
}

resource "azurerm_federated_identity_credential" "terraform" {
  name                = substr(replace("${var.azure_devops_organization_name}--${var.azure_devops_project_name}--${var.azure_devops_service_connection_name}", " ", ""), 0, 120)
  resource_group_name = azurerm_resource_group.terraform.name
  parent_id           = azurerm_user_assigned_identity.terraform.id
  audience            = ["api://AzureADTokenExchange"]
  subject             = azuredevops_serviceendpoint_azurerm.terraform.workload_identity_federation_subject
  issuer              = azuredevops_serviceendpoint_azurerm.terraform.workload_identity_federation_issuer
}

// Optional pipeline file in the repository

// Optional set of Terraform files in the repository - shame there is no equivalent of template_dir

resource "azuredevops_git_repository_file" "terraform" {
  for_each = var.azure_devops_create_files ? {
    "main.tf" : {
      source = "files/main.tftpl"
      vars   = { subscription_id = var.subscription_id }
    },
    "provider.tf" : {
      source = "files/provider.tftpl"
      vars   = {}
    },

  } : {}

  repository_id       = data.azuredevops_git_repository.repo.id
  file                = each.key
  branch              = "refs/heads/main"
  commit_message      = "Initial commit"
  overwrite_on_create = false

  content = templatefile("${path.module}/files/main.tftpl", { subscription_id = var.subscription_id })
}