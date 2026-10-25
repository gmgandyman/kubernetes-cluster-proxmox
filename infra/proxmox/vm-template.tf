locals {
  debian_custom_image_path = "${path.module}/../../packer/output/debian/debian_bookworm.qcow2"
}

# Our own packer-built image, not the vanilla upstream cloud image - this is what gets
# qemu-guest-agent baked in and enabled before the VM ever boots for real (see
# packer/debian.base.pkr.hcl and packer/scripts/debian.base/install-base-packages.sh).
# Run toolbox/scripts/build-images.sh then flatten-images.sh first to produce this file.
# content_type "import" uses Proxmox's plain upload API (same auth as the rest of this
# provider config); this only uploads the image - the actual Proxmox template is below at
# proxmox_virtual_environment_vm.debian_template.
resource "proxmox_virtual_environment_file" "debian_custom_image" {
  content_type = "import"
  datastore_id = var.image_storage
  node_name    = var.node_name
  overwrite    = true

  source_file {
    path      = local.debian_custom_image_path
    file_name = "k8s-debian-12-custom.qcow2"
    checksum  = filesha256(local.debian_custom_image_path)
  }
}

resource "proxmox_virtual_environment_vm" "debian_template" {
  name      = var.template_name
  node_name = var.node_name
  vm_id     = var.template_vm_id

  template = true
  started  = false   # templates don't run

  cpu    { cores = 1 }
  memory { dedicated = 1024 }

  disk {
    datastore_id = var.disk_storage
    import_from  = proxmox_virtual_environment_file.debian_custom_image.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = var.template_disk_size
  }

  initialization {
    datastore_id = var.disk_storage
    interface    = "ide2"

    user_account {
      username = var.vm_default_username
      keys     = var.ssh_public_keys
    }
  }

  # Debian cloud images assume a serial console; VNC/std display has no
  # scrollback, so use serial for a real terminal (scrollback + `qm terminal`).
  serial_device {}
  vga {
    type = "serial0"
  }
}
