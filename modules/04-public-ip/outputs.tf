output "out_child_public_ip_ids" {
  description = "Map of public IP names to their IDs"
  value       = { for k, v in azurerm_public_ip.child_public_ip : k => v.id }
}

###############################
# Below is the output
###############################
# public_ip_ids = {
#   "public_ip1" = "/subscriptions/xxx-xxx-xxx-xxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/publicIPAddresses/eagle-pip1",
#   "public_ip2" = "/subscriptions/xxx-xxx-xxx-xxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/publicIPAddresses/eagle-pip-2-bastion"
# }
###############################

# ✅ Usage Example (in another module)
# If your NIC or Bastion host needs to use one of these public IPs:
# public_ip_address_id = var.public_ip_ids["public_ip2"]

# Terraform will substitute it with:
# /subscriptions/xxx-xxx-xxx-xxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/publicIPAddresses/eagle-pip-2-bastion



output "out_child_public_ip_names_to_ips" {
  value = { for k, v in azurerm_public_ip.child_public_ip : v.name => v.ip_address }
}

###############################
# Below is the output
###############################
# {
#   "eagle-pip1" = "48.194.58.103",
#   "eagle-pip-2-bastion" = "48.194.113.126"
# }


output "out_child_public_ip_details" {
  description = "Map of public IPs with name, address, and ID"
  value = {
    for k, v in azurerm_public_ip.child_public_ip :
    k => {
      name        = v.name
      ip_address  = v.ip_address
      id          = v.id
    }
  }
}

###############################
# Below is the output
###############################
# {
#   "public_ip1": {
#     "name": "eagle-pip1",
#     "ip_address": "48.194.58.103",
#     "id": "/subscriptions/xxx-xxx-xxx-xxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/publicIPAddresses/eagle-pip1"
#   },
#   "public_ip2": {
#     "name": "eagle-pip-2-bastion",
#     "ip_address": "48.194.113.126",
#     "id": "/subscriptions/xxx-xxx-xxx-xxx/resourceGroups/eagle-rg1/providers/Microsoft.Network/publicIPAddresses/eagle-pip-2-bastion"
#   }
# }
###############################