resource "proxmox_virtual_environment_vm" "control_plane" {
  name      = "k8s-control-plane"
  node_name = var.node_name
  vm_id     = var.control_plane_vm_id

  clone {
    vm_id = proxmox_virtual_environment_vm.debian_template.vm_id
    full  = true
  }

  cpu    { cores = var.control_plane_cores }
  memory { dedicated = var.control_plane_memory }

  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = var.control_plane_disk_size
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
        address = var.control_plane_ip_cidr
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

  agent { enabled = true }   # safe because the template has qemu-guest-agent baked in and enabled - see vm-template.tf

  # Debian cloud images assume a serial console; VNC/std display has no
  # scrollback, so use serial for a real terminal (scrollback + `qm terminal`).
  serial_device {}
  vga {
    type = "serial0"
  }
}
