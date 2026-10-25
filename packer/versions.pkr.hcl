packer {
    required_plugins {
        qemu = {
            version = ">= 1.1.0"
            source  = "github.com/hashicorp/qemu"
        }
    }
}
