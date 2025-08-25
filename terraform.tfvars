resource_group_name = "terraform"

vm_instances = {
  analytics-vm = {
    name     = "analytics-vm"
    size     = "Standard_B2s"
    location = "centralindia"
    os_type  = "linux"
  }
}
