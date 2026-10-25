# This qemu source boots the same genericcloud image infra/proxmox/vm-template.tf would
# otherwise have downloaded directly, so cloud-init/package-manager/networking behavior
# stays close to the real VM. The output of this build is the actual template disk -
# toolbox/scripts/flatten-images.sh + infra/proxmox/vm-template.tf's
# proxmox_virtual_environment_file resource upload it as-is.
source "qemu" "debian_bookworm" {
    iso_url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"

    # "latest" is a rolling pointer, so there's no stable checksum to pin against
    iso_checksum = "none"

    disk_image       = true
    use_backing_file = true
    disk_size        = "10240M" # matches infra/proxmox's template_disk_size (10GB)

    output_directory = "${var.output_root}/debian"

    # No hardware virtualization available inside the (nested) toolbox container, so this
    # will run under software emulation - slow, but accurate to the real amd64 target
    accelerator = "tcg"

    headless    = true
    ssh_timeout = "2m"

    communicator         = "ssh"
    ssh_username         = "root"
    ssh_private_key_file = var.deploy_private_key_path

    cd_label = "cidata"
    cd_content = {
        "meta-data" = "instance-id: debian-base-packer\nlocal-hostname: debian-base-packer\n"
        "user-data" = templatefile("${abspath(path.root)}/cloud-init/user-data.pkrtpl.hcl", {
            ssh_public_key = trimspace(file(var.public_key_path))
        })
    }

    shutdown_command = "poweroff"
}

locals {
    debian_base_scripts_dir = "${var.scripts_root}/debian.base"
}

build {
    name = "debian-custom"
    sources = [
        "source.qemu.debian_bookworm"
    ]

    // Cloud-init's later stages (network/hostname finalization) can still be running
    // when Packer first connects, which can drop the SSH session mid-script if a later
    // provisioner races with it - wait for cloud-init to fully settle first
    provisioner "shell" {
        # exit 2 = cloud-init finished but a stage hit a recoverable error - tolerate it
        # and print the detail so we can actually see what's degraded
        valid_exit_codes = [0, 2]
        inline = [
            "cloud-init status --wait",
            "cloud-init status --long"
        ]
    }

    provisioner "shell" {
        environment_vars = [
            "DEBIAN_FRONTEND=noninteractive"
        ]

        scripts = [
            "${local.debian_base_scripts_dir}/init-apt.sh",
            "${local.debian_base_scripts_dir}/install-base-packages.sh",
            "${local.debian_base_scripts_dir}/install-sshd.sh",
            "${local.debian_base_scripts_dir}/setup-nopasswd-sudo.sh"
        ]
    }

    // Upload the master key's public key to the server, just use tmp for now
    provisioner "file" {
        source      = var.public_key_path
        destination = "/tmp/master_key.pub"
    }

    provisioner "shell" {
        scripts = [
            "${local.debian_base_scripts_dir}/add-deploy-user.sh",
            "${local.debian_base_scripts_dir}/setup-ssh-directory.sh",
            "${local.debian_base_scripts_dir}/cleanup.sh"
        ]
    }
}
