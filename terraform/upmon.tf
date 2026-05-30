locals {
  upmon_checks = {
    for vm in yandex_compute_instance.web :
    vm.name => {
      name = "Wiki.js local check ${vm.name}"
      slug = "${vm.name}-wikijs-local"
    }
  }
}

data "external" "upmon_check" {
  for_each = local.upmon_checks

  program = ["python3", "${path.module}/scripts/upmon_check.py"]

  query = {
    api_key = var.upmon_api_key
    name    = each.value.name
    slug    = each.value.slug
    tags    = "wikijs terraform ${each.key}"
    desc    = "Checks Wiki.js local HTTP endpoint on ${each.key}"
    timeout = "120"
    grace   = "120"
  }
}

resource "local_sensitive_file" "upmon_checks" {
  filename = "${path.module}/../ansible/upmon_checks.yml"

  content = yamlencode({
    upmon_checks = {
      for hostname, check in data.external.upmon_check :
      hostname => {
        ping_url = check.result.ping_url
      }
    }
  })
}
