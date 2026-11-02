# Packer plugin versions, not the actual installed linux versions
packer {
    required_plugins {
        qemu = {
            version = "1.1.7"
            source  = "github.com/hashicorp/qemu"
        }
        ansible = {
            version = "1.1.6"
            source  = "github.com/hashicorp/ansible"
        }
    }
}
