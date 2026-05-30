terraform {
  required_version = ">= 1.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.204"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.0"
    }

  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}
