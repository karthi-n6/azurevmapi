admin_username = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

vm_instances = {
  analytics-vm = {
    name     = "analytics-vm"
    size     = "Standard_B2s"
    location = "eastus"
    os_type  = "linux"
  }
}
