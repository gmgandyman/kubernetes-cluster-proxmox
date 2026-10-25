variable "storage_vm_id" {
  type    = number
  default = null
}

variable "storage_ip_cidr" {
  description = "e.g. 192.168.1.13/24"
  type        = string
}

variable "storage_cores" {
  default = 1
}

variable "storage_memory" {
  default = 12 * 1024
}

variable "storage_disk_size" {
  default = 20
}
