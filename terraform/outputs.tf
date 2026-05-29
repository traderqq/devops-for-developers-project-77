output "web_external_ips" {
  value = [
    for vm in yandex_compute_instance.web :
    vm.network_interface[0].nat_ip_address
  ]
}

output "web_internal_ips" {
  value = [
    for vm in yandex_compute_instance.web :
    vm.network_interface[0].ip_address
  ]
}

output "postgres_fqdn" {
  value = yandex_mdb_postgresql_cluster.wikijs.host[0].fqdn
}

output "alb_ip_address" {
  value = yandex_alb_load_balancer.web.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "dns_instruction" {
  value = "Create A record: ${var.app_domain} -> ${yandex_alb_load_balancer.web.listener[0].endpoint[0].address[0].external_ipv4_address[0].address}"
}

output "app_url" {
  value = "https://${var.app_domain}"
}
