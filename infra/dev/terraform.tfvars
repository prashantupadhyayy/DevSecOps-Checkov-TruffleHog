var_root_dev_resource_group = {
  resource_group1 = {
    resource_group_name = "eagle-rg1"
    location            = "australiaeast"
    tags = {
      env      = "dev"
      resource = "resource_group"
      app      = "terraform"
      env_type = "common"
    }
  }
}


var_root_dev_vnet = {
  vnet1 = {
    # Required variables of VNet
    vnet_name           = "eagle-vnet1"
    location            = "australiaeast"
    resource_group_name = "eagle-rg1"
    address_space       = ["10.0.0.0/16"]
    dns_servers         = ["10.0.0.4", "10.0.0.5"]

    tags = {
      env      = "dev"
      resource = "vnet"
      app      = "terraform"
      env_type = "common"
    }
  }
}


var_root_dev_subnet = {
  subnet1 = {
    subnet_name          = "eagle-subnet1-frontend"
    virtual_network_name = "eagle-vnet1"
    vnet_key             = "vnet1"
    resource_group_name  = "eagle-rg1"
    address_prefixes     = ["10.0.1.0/24"]
  }
  subnet2 = {
    subnet_name          = "eagle-subnet2-backend"
    virtual_network_name = "eagle-vnet1"
    vnet_key             = "vnet1"
    resource_group_name  = "eagle-rg1"
    address_prefixes     = ["10.0.2.0/24"]
  }
}


var_root_dev_public_ip = {
  public_ip1 = {
    # Required variables of Public IP
    vnet_name           = "eagle-vnet1"
    location            = "australiaeast"
    public_ip_name      = "eagle-pip1-frontend"
    allocation_method   = "Static"
    resource_group_name = "eagle-rg1"

    # Optional variables of Public IP
    sku                     = "Standard"
    sku_tier                = "Regional"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = 10
    zones                   = ["1", "2", "3"]

    public_ip_tags = {
      env      = "dev"
      resource = "public_ip"
      app      = "terraform"
      env_type = "frontend"
    }
  }
  public_ip2 = {
    # Required variables of Public IP
    vnet_name           = "eagle-vnet1"
    location            = "australiaeast"
    public_ip_name      = "eagle-pip2-backend"
    allocation_method   = "Static"
    resource_group_name = "eagle-rg1"

    # Optional variables of Public IP
    sku                     = "Standard"
    sku_tier                = "Regional"
    ip_version              = "IPv4"
    idle_timeout_in_minutes = 10
    zones                   = ["1", "2", "3"]

    public_ip_tags = {
      env      = "dev"
      resource = "public_ip"
      app      = "terraform"
      env_type = "backend"
    }
  }
}


var_root_dev_nsg = {
  nsg1 = {
    name                = "eagle-nsg1-frontend"
    location            = "australiaeast"
    resource_group_name = "eagle-rg1"

    tags = {
      env      = "dev"
      resource = "nsg"
      app      = "terraform"
      env_type = "frontend"
    }

    security_rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }

  nsg2 = {
    name                = "eagle-nsg2-backend"
    location            = "australiaeast"
    resource_group_name = "eagle-rg1"

    tags = {
      env      = "dev"
      resource = "nsg"
      app      = "terraform"
      env_type = "backend"
    }

    security_rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
}


var_root_dev_nic = {
  nic_vm1 = {
    name                           = "eagle-nic1-frontend"
    location                       = "australiaeast"
    resource_group_name            = "eagle-rg1"
    accelerated_networking_enabled = false
    ip_forwarding_enabled          = false

    tags = {
      env      = "dev"
      resource = "nic"
      app      = "terraform"
      env_type = "frontend"
    }

    subnet_key           = "subnet1"
    subnet_name          = "eagle-subnet1-frontend"
    virtual_network_name = "eagle-vnet1"
    public_ip_name       = "eagle-pip1-frontend"
    nsg_key              = "eagle-nsg1-frontend"

    ip_configurations = [
      {
        name                          = "eagle-ipconfig1-frontend"
        private_ip_address_allocation = "Dynamic"
        primary                       = true
      }
    ]
  }

  nic_vm2 = {
    name                = "eagle-nic2-backend"
    location            = "australiaeast"
    resource_group_name = "eagle-rg1"

    tags = {
      env      = "dev"
      resource = "nic"
      app      = "terraform"
      env_type = "backend"
    }
    subnet_key           = "subnet2"
    subnet_name          = "eagle-subnet2-backend"
    virtual_network_name = "eagle-vnet1"
    public_ip_name       = "eagle-pip2-backend"
    nsg_key              = "eagle-nsg2-backend"

    ip_configurations = [
      {
        name                          = "eagle-ipconfig2-backend"
        private_ip_address_allocation = "Dynamic"
        primary                       = true
      }
    ]
  }
}

var_root_dev_vms = {
  vm1 = {
    name                = "eagle-vm1-frontend"
    location            = "australiaeast"
    resource_group_name = "eagle-rg1"
    size                = "Standard_B1ms"

    key_Vault_name                = "ankurKeyVault2"
    key_Vault_resource_group_name = "ankur-rg2-keyvault"

    admin_username_key              = "vmuser"
    admin_password_key              = "vmpassword"
    disable_password_authentication = false

    # network_interface_id         = "/subscriptions/xxxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/networkInterfaces/eagle-nic-frontend"
    nic_name             = "eagle-nic1-frontend"
    storage_account_type = "Standard_LRS"

    image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

    computer_name = "frontendvm"

    tags = {
      env      = "dev"
      resource = "vm"
      app      = "terraform"
      env_type = "frontend"
    }
  }

  vm2 = {
    name                = "eagle-vm2-backend"
    location            = "australiaeast"
    resource_group_name = "eagle-rg1"
    size                = "Standard_B1s"

    key_Vault_name                = "ankurKeyVault2"
    key_Vault_resource_group_name = "ankur-rg2-keyvault"

    admin_username_key              = "vmuser"
    admin_password_key              = "vmpassword"
    disable_password_authentication = false

    # network_interface_id = "/subscriptions/xxxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/networkInterfaces/eagle-nic-backend"
    nic_name             = "eagle-nic2-backend"
    storage_account_type = "Standard_LRS"

    image = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

    computer_name = "backendvm"

    tags = {
      env      = "dev"
      resource = "vm"
      app      = "terraform"
      env_type = "backend"
    }
  }
}

var_root_dev_sql_server = {
  sql_server_1 = {
    sql_server_name               = "eagle-sql-server1"
    resource_group_name           = "eagle-rg1"
    location                      = "australiaeast"
    sql_server_version            = "12.0"
    minimum_tls_version           = "1.2"
    public_network_access_enabled = true
    identity_type                 = "SystemAssigned"

    # Key Vault variables
    key_Vault_name                = "ankurKeyVault2"
    key_Vault_resource_group_name = "ankur-rg2-keyvault"

    sql_username_key = "sqluser"
    sql_password_key = "sqlpassword"

    # # Will be called using Azure Key Vault
    # administrator_login = string
    # administrator_login_password = string
  }
}



var_root_dev_mssql_databases = {
  db1 = {
    name         = "eagle-sql-database1"
    # server_id    = data.azurerm_mssql_server.get_child_sql_server[each.key].id
    collation    = "SQL_Latin1_General_CP1_CI_AS"
    license_type = "LicenseIncluded"
    max_size_gb  = 2 # Size in GB
    sku_name     = "S0"
    enclave_type = "VBS"

    tags = {
      env      = "dev"
      resource = "sql-database"
      app      = "terraform"
      env_type = "common"
    }

    sql_server_name = "eagle-sql-server1"
    resource_group_name = "eagle-rg1"
  }
}
