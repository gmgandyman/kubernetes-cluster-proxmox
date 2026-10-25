variable "control_plane_vm_id" {
  type    = number
  default = null
}

variable "control_plane_ip_cidr" {
  description = "e.g. 192.168.1.11/24"
  type        = string
}

variable "control_plane_cores" {
  default = 2
}

variable "control_plane_memory" {
  default = 4 * 1024
}

variable "control_plane_disk_size" {
  default = 10
}
