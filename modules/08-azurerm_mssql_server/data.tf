data "external" "get_my_ip" {
  depends_on = [null_resource.set_execution_policy]
  program    = ["powershell", "-File", "${path.module}/../../infra/scripts/get_ip.ps1"] # For Windows
}

data "azurerm_mssql_server" "get_child_sql_server" {

depends_on = [azurerm_mssql_server.child_sqlserver]

for_each = var.var_child_sql_server

  name                = each.value.sql_server_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault" "get_azure_key_vault_1" {
  for_each = var.var_child_sql_server

  name                = each.value.key_Vault_name
  resource_group_name = each.value.key_Vault_resource_group_name
}

data "azurerm_key_vault_secret" "get_key_vault_secret_sql_username_1" {
  for_each = var.var_child_sql_server

  name         = each.value.sql_username_key
  key_vault_id = data.azurerm_key_vault.get_azure_key_vault_1[each.key].id
}

data "azurerm_key_vault_secret" "get_key_vault_secret_sql_password_1" {
  for_each = var.var_child_sql_server

  name         = each.value.sql_password_key
  key_vault_id = data.azurerm_key_vault.get_azure_key_vault_1[each.key].id
}