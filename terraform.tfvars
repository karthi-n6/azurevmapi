resource_group_name = "my-existing-rg"

vm_instances = {
  analytics-vm = {
    name     = "analytics-vm"
    size     = "Standard_B2s"
    location = "eastus"
    os_type  = "linux"
  }
}
