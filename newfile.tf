data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "keyrg" {
  name     = "keyrg"
  location = "West Europe"
}

resource "azurerm_key_vault" "cloud" {
  name                        = "ronumonukeyvault"
  location                    = azurerm_resource_group.keyrg.location
  resource_group_name         = azurerm_resource_group.keyrg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "keysecret" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.cloud.id
}
