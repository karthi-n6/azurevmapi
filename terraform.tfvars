location   = "eastus"
vm_size    = "Standard_B1s"
vm_names   = ["analytics-vm"]
admin_username = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

To add a new VM entry for the user request into the `terraform.tfvars` file in HCL format, you can create a variable block as follows:

```hcl
vm_name = "build_a_new_vm_name"
vm_type = "python"
vm_action = "add"
vm_script = "add-vm.py"
```

You can adjust the variable names and values as needed to fit your specific Terraform configuration. The above block can be appended directly to your `terraform.tfvars` file.
