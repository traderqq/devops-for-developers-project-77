variable "yc_token" {
  type      = string
  sensitive = true
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vm_user" {
  type    = string
  default = "ubuntu"
}

variable "ssh_public_key_path" {
  type = string
}
