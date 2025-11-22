resource "azurerm_mssql_server" "child_sqlserver" {
  for_each = var.var_child_sql_server

  name                = each.value.sql_server_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  version             = each.value.sql_server_version
  minimum_tls_version = each.value.minimum_tls_version

  # 🔐 Use a Azure Key Vault in production environments.
  administrator_login = data.azurerm_key_vault_secret.get_key_vault_secret_sql_username_1[each.key].value

  # 🔐 Use a Azure Key Vault in production environments.
  administrator_login_password = data.azurerm_key_vault_secret.get_key_vault_secret_sql_password_1[each.key].value

  public_network_access_enabled = each.value.public_network_access_enabled

  identity {
    type = each.value.identity_type
  }
}

resource "null_resource" "set_execution_policy" {
  depends_on = [azurerm_mssql_server.child_sqlserver]

  provisioner "local-exec" {
    command = "powershell -Command \"Set-ExecutionPolicy Bypass -Scope Process -Force\""
  }
}

resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  depends_on = [azurerm_mssql_server.child_sqlserver, null_resource.set_execution_policy]
for_each = var.var_child_sql_server

  name             = "AllowMyHomeIP"
  server_id        = data.azurerm_mssql_server.get_child_sql_server[each.key].id
  start_ip_address = data.external.get_my_ip.result.public_ip
  end_ip_address   = data.external.get_my_ip.result.public_ip
}


