# Global stuff

variable "scripts_root" {
    type    = string
    default = "packer/scripts"
}

variable "output_root" {
    type    = string
    default = "packer/output"
}

variable "public_key_path" {
    type    = string
    default = env("DEPLOY_PUBLIC_KEY_PATH")
}

variable "deploy_private_key_path" {
    type    = string
    default = env("DEPLOY_PRIVATE_KEY_PATH")
}
