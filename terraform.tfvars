location   = "eastus"
vm_size    = "Standard_B1s"
vm_names   = ["analytics-vm"]
admin_username = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"

To append the new VM entry to your `terraform.tfvars` file, you can use the following HCL block:

```hcl
vm "analytics-vm" {
  size   = "Standard_B2s"
  region = "eastus"
}
```

Make sure to append this block to your `terraform.tfvars` file under the appropriate variable section, or directly if it is structured to accept multiple VM entries like shown.
