resource "yandex_alb_target_group" "web" {
  name = "${var.project_name}-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.main.id
    ip_address = yandex_compute_instance.web[0].network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.main.id
    ip_address = yandex_compute_instance.web[1].network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "web" {
  name = "${var.project_name}-backend-group"

  http_backend {
    name             = "${var.project_name}-http-backend"
    weight           = 1
    port             = 3000
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout  = "5s"
      interval = "10s"

      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web" {
  name = "${var.project_name}-router"
}

resource "yandex_alb_virtual_host" "web" {
  name           = "${var.project_name}-virtual-host"
  http_router_id = yandex_alb_http_router.web.id
  authority      = [var.app_domain]

  route {
    name = "${var.project_name}-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
        timeout          = "60s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web" {
  name               = "${var.project_name}-alb"
  network_id         = yandex_vpc_network.main.id
  security_group_ids = [yandex_vpc_security_group.alb.id]

  allocation_policy {
    location {
      zone_id   = var.zone
      subnet_id = yandex_vpc_subnet.main.id
    }
  }

  listener {
    name = "${var.project_name}-https-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }

      ports = [443]
    }

    tls {
      default_handler {
        certificate_ids = [data.yandex_cm_certificate.app.id]

        http_handler {
          http_router_id = yandex_alb_http_router.web.id
        }
      }
    }
  }
}
