variable "proxmox_endpoint" {
  description = "e.g. https://pve.example.com:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "Format: user@pam!tokenid=uuid"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (only if using a self-signed cert without importing it)"
  type        = bool
  default     = false
}

variable "node_name" {
  description = "Target Proxmox node name"
  type        = string
}

variable "network_bridge" {
  description = "Bridge the cluster VMs attach to"
  default     = "vmbr0"
}

variable "network_vlan_id" {
  description = "Optional VLAN tag for the cluster network_device; leave null for untagged"
  type        = number
  default     = null
}

variable "image_storage" {
  description = "Datastore the downloaded cloud image is stored on"
  default     = "local"
}

variable "disk_storage" {
  description = "Datastore VM disks are created on"
  default     = "local-lvm"
}
