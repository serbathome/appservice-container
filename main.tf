terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "group-acr" {
  name     = "container-registries-${random_string.random.result}"
  location = "West Europe"
}

resource "azurerm_container_registry" "acr" {
  name                = "ptacr${random_string.random.result}"
  resource_group_name = azurerm_resource_group.group-acr.name
  location            = azurerm_resource_group.group-acr.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "random_string" "random" {
  length  = 4
  special = false
}

resource "null_resource" "build_and_push_image" {
  provisioner "local-exec" {
    command = <<-EOT
      az acr build \
        --registry ${azurerm_container_registry.acr.login_server} \
        --image sample/hello-world:1 \
        --file ./Dockerfile \
        .
    EOT
  }
  triggers = {
    random_trigger = random_string.random.result
  }
  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_resource_group" "group-mi" {
  name     = "managed-identities-${random_string.random.result}"
  location = "West Europe"
}

resource "azurerm_user_assigned_identity" "mi" {
  location            = azurerm_resource_group.group-mi.location
  name                = "provider-tools-web-app-mi-${random_string.random.result}"
  resource_group_name = azurerm_resource_group.group-mi.name
}

resource "azurerm_role_assignment" "ra" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

resource "azurerm_resource_group" "group-appservice" {
  name     = "appservices-${random_string.random.result}"
  location = "West Europe"
}

resource "azurerm_service_plan" "asp" {
  name                = "provider-tools-asp-${random_string.random.result}"
  location            = azurerm_resource_group.group-appservice.location
  resource_group_name = azurerm_resource_group.group-appservice.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_app_service" "app-service" {
  name                = "provider-tools-appservice-${random_string.random.result}"
  resource_group_name = azurerm_resource_group.group-appservice.name
  location            = azurerm_resource_group.group-appservice.location
  app_service_plan_id = azurerm_service_plan.asp.id

  site_config {
    always_on                            = true
    linux_fx_version                     = "DOCKER|${azurerm_container_registry.acr.login_server}/sample/hello-world:1"
    acr_use_managed_identity_credentials = true
    acr_user_managed_identity_client_id  = azurerm_user_assigned_identity.mi.client_id
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = azurerm_container_registry.acr.login_server
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }
  depends_on = [null_resource.build_and_push_image]
}

output "privider-tools-acr-login-server" {
  value = azurerm_container_registry.acr.login_server
}

output "provider-tools-appservice-resource-group" {
  value = azurerm_resource_group.group-appservice.name
}

output "provider-tools-appservice-name" {
  value = azurerm_app_service.app-service.name
}

