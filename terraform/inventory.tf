resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/inventory.ini.tftpl", {
    vm_user     = var.vm_user
    ssh_private_key_path = var.ssh_private_key_path
    web_servers = yandex_compute_instance.web
    db_host     = yandex_mdb_postgresql_cluster.wikijs.host[0].fqdn
    db_port     = 6432
    db_name     = yandex_mdb_postgresql_database.wikijs.name
    db_user     = yandex_mdb_postgresql_user.wikijs.name
    db_password = var.db_password
    app_domain  = var.app_domain
  })
}
