resource "yandex_mdb_postgresql_cluster" "wikijs" {
  name        = "${var.project_name}-postgres"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.main.id

  security_group_ids = [
    yandex_vpc_security_group.db.id
  ]

  config {
    version = 16

    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
  }

  host {
    zone      = var.zone
    subnet_id = yandex_vpc_subnet.main.id
  }
}

resource "yandex_mdb_postgresql_user" "wikijs" {
  cluster_id = yandex_mdb_postgresql_cluster.wikijs.id
  name       = var.db_user
  password   = var.db_password
  conn_limit = 50
}

resource "yandex_mdb_postgresql_database" "wikijs" {
  cluster_id = yandex_mdb_postgresql_cluster.wikijs.id
  name       = var.db_name
  owner      = yandex_mdb_postgresql_user.wikijs.name
}
