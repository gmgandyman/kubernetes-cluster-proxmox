terraform {
  required_version = ">= 1.7.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.114.0"   # pin to whatever you've actually tested
    }
  }
}
