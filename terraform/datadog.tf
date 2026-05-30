resource "datadog_monitor" "wikijs_local_http_check" {
  name = "Wiki.js local HTTP check"

  type = "service check"

  query = "\"http.can_connect\".over(\"instance:wikijs_local\",\"project:wikijs\",\"service:wikijs\").by(\"host\").last(2).count_by_status()"

  message = <<EOT
Wiki.js local HTTP check failed on {{host.name}}.

The Datadog Agent cannot reach http://127.0.0.1:3000/ on the application server.
Check Docker container status, Wiki.js logs, and PostgreSQL connectivity.
EOT

  monitor_thresholds {
    critical = 2
    warning  = 1
  }

  notify_no_data      = true
  no_data_timeframe   = 10
  renotify_interval   = 30
  include_tags        = true
  require_full_window = false

  tags = [
    "env:dev",
    "project:wikijs",
    "service:wikijs",
    "managed_by:terraform"
  ]
}
