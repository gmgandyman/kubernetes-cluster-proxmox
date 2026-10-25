resource "proxmox_virtual_environment_vm" "worker" {
  name      = "k8s-worker"
  node_name = var.node_name
  vm_id     = var.worker_vm_id

  clone {
    vm_id = proxmox_virtual_environment_vm.debian_template.vm_id
    full  = true
  }

  cpu    { cores = var.worker_cores }
  memory { dedicated = var.worker_memory }

  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = var.worker_disk_size
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.network_vlan_id
  }

  initialization {
    datastore_id = var.disk_storage
    interface    = "ide2"

    ip_config {
      ipv4 {
        address = var.worker_ip_cidr
        gateway = var.gateway_ip
      }
    }

    dns {
      servers = [var.dns_server]
    }

    user_account {
      username = var.vm_default_username
      keys     = var.ssh_public_keys
    }
  }

  agent { enabled = true }

  serial_device {}
  vga {
    type = "serial0"
  }
}
