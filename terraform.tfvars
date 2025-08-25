vm_config = {
  "vm1" = {
    size = "Standard_B1s"
    region = "eastus"
  }
  "vm2" = {
    size = "Standard_B2s"
    region = "eastus"
  }
}

To add the requested VM entry for `analytics-vm` in the Terraform variable block format, you can use the following HCL code snippet. This assumes you have a variable defined for VM instances in your `terraform.tfvars` file.

Here’s the new entry you can append:

```hcl
vm_instances = [
  {
    name   = "analytics-vm"
    size   = "Standard_B2s"
    region = "eastus"
  }
]
```

You can append this to your existing `terraform.tfvars` file under the appropriate variable for your VM instances. If you have other VM entries in an array, make sure to include this new entry within that array.
