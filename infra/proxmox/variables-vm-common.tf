variable "ssh_public_keys" {
  description = "Injected into cloud-init for all cluster VMs"
  type        = list(string)
}

variable "vm_default_username" {
  default = "debian"
}

variable "gateway_ip" {
  description = "LAN gateway the cluster VMs use, e.g. 192.168.1.1"
  type        = string
}

variable "dns_server" {
  description = "DNS resolver for the cluster VMs"
  type        = string
  default     = "1.1.1.1"
}
