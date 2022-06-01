variable "vsphere_server" {
    type = string
    description = "The FQDN of the vCenter Server"
}

variable "vms" {
    type = map
    description = "List of VMs to create"
}