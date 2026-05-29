resource "yandex_vpc_security_group" "alb" {
  name       = "${var.project_name}-alb-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    description    = "HTTPS from internet"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "web" {
  name       = "${var.project_name}-web-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    description    = "SSH for Ansible"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description       = "Wiki.js from ALB"
    protocol          = "TCP"
    port              = 3000
    security_group_id = yandex_vpc_security_group.alb.id
  }

  ingress {
    description       = "ALB health checks"
    protocol          = "TCP"
    port              = 3000
    predefined_target = "loadbalancer_healthchecks"
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "db" {
  name       = "${var.project_name}-db-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    description       = "PostgreSQL from web servers"
    protocol          = "TCP"
    port              = 6432
    security_group_id = yandex_vpc_security_group.web.id
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
