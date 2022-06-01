provider "vsphere" {
    vsphere_server = var.vsphere_server
}

data "vsphere_datacenter" "dc" {
    name = "Data Center"
}

data "vsphere_datastore" "datastore" {
    name = "Silver"
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
    name = "Test"
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
    name = "VM_Network"
    datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
    name = "TMPL_UBUNTU1804"
    datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
    for_each            = var.vms
    name                = each.value.name
    resource_pool_id    = data.vsphere_compute_cluster.cluster.resource_pool_id
    datastore_id        = data.vsphere_datastore.datastore.id

    num_cpus    = 2
    memory      = 4096
    guest_id    = data.vsphere_virtual_machine.template.guest_id
    network_interface {
      network_id = data.vsphere_network.network.id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
    disk {
        label = "disk0"
        size  = data.vsphere_virtual_machine.template.disks.0.size
        thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    }
    wait_for_guest_net_timeout = 0

    clone {
        template_uuid = data.vsphere_virtual_machine.template.id
    }
}