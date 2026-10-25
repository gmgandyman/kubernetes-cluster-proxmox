variable "worker_vm_id" {
  type    = number
  default = null
}

variable "worker_ip_cidr" {
  description = "e.g. 192.168.1.12/24"
  type        = string
}

variable "worker_cores" {
  default = 1
}

variable "worker_memory" {
  default = 8 * 1024
}

variable "worker_disk_size" {
  default = 15
}
