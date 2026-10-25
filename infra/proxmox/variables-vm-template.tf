variable "template_name" {
  default = "k8n-debian-12-cloudinit-template"
}

variable "template_vm_id" {
  type        = number
  default     = 9000   # convention: reserve 9000+ for templates so they're easy to spot in the UI
}

variable "template_disk_size" {
  description = "Base template disk size in GB; each cloned VM overrides this with its own disk.size"
  type        = number
  default     = 10
}
