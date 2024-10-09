variable "azure_devops_organization_name" {
  type        = string
  description = "value of the Azure DevOps organization name"
}

variable "azure_devops_project_name" {
  type        = string
  description = "value of the Azure DevOps project name"
}

variable "azure_devops_variable_group_name" {
  type        = string
  description = "value of the Azure DevOps variable group name"
}

variable "resource_group_name" {
  type        = string
  description = "value of the Azure resource group name"
}

variable "storage_account_name" {
  type        = string
  description = "value of the Azure storage account name"
}

variable "storage_container_name" {
  type        = string
  description = "value of the Azure storage container name"
}

variable "azure_devops_service_connection_name" {
  type        = string
  description = "value of the Azure DevOps service connection name"
}

variable "client_id" {
  type        = string
  description = "value of the Azure client ID"
}

variable "tenant_id" {
  type        = string
  description = "value of the Azure tenant ID"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "subscription_display_name" {
  type = string
  description = "value of the Azure subscription display name"
}

variable "managed_identity_id" {
  type        = string
  description = "Resource ID of the Azure managed identity"
}

variable "azure_devops_personal_access_token" {
  type        = string
  description = "value of the Azure DevOps fine grained personal access token"
}
