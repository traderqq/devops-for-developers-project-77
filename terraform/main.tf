resource "yandex_vpc_network" "main" {
  name = "hexlet-network"
}

resource "yandex_vpc_subnet" "main" {
  name           = "hexlet-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_instance" "web" {
  name        = "hexlet-web"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.vm_user}:${file(var.ssh_public_key_path)}"
  }
}
