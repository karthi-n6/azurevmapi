terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id      =  var.subscription_id
  tenant_id            =  var.tenant_id
  client_id            =  var.client_id
  client_secret        =  var.client_secret
}



# -------------------------
# Variables
# -------------------------
variable "subscription_id" {
  type = string
  description = "Azure subscription id to provision infra."
 }
        
variable "tenant_id" {
  type = string
  description = "Azure subscription tenant id"
}
    
variable "client_id" {
  type = string
  description = "App id to authenticate to azure."
}
    
variable "client_secret" {
  type = string
  description = "App password to authenticate to azure"
}

variable "location" {
  default = "eastus"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "vm_names" {
  description = "List of VM names"
  type        = list(string)
  default     = ["vm1"]
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

# -------------------------
# Networking
# -------------------------
resource "azurerm_resource_group" "main" {
  name     = "rg-simple-vm"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-simple"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-simple"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# -------------------------
# VM Creation Loop
# -------------------------
# One NIC per VM
resource "azurerm_network_interface" "nics" {
  for_each = toset(var.vm_names)

  name                = "nic-${each.value}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

# One VM per name
resource "azurerm_linux_virtual_machine" "vms" {
  for_each            = toset(var.vm_names)

  name                = each.value
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nics[each.value].id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
