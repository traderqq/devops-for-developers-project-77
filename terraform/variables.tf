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

variable "ssh_private_key_path" {
  type    = string
  default = "~/.ssh/yandex.pem.txt"
}

variable "app_domain" {
  type    = string
  default = "birchcapital.space"
}

variable "certificate_id" {
  type        = string
  description = "Existing Yandex Certificate Manager certificate ID"
}

variable "project_name" {
  type    = string
  default = "wikijs"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/24"
}

variable "db_name" {
  type    = string
  default = "wiki"
}

variable "db_user" {
  type    = string
  default = "wikijs"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "ssh_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
