variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "vm_instances" {
  description = "Map of VM configurations"
  type = map(object({
    name     = string
    size     = string
    location = string
    os_type  = string
  }))
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each            = var.vm_instances
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.location
  size                = each.value.size
}
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.vm_names)
  name                = "${each.key}-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}
