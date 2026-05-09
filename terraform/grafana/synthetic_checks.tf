locals {
  probe_london    = 14
  check_frequency = 600000
  check_timeout   = 3000

  synthetic_checks = {
    pez_sh            = { job = "pez.sh", target = "https://pez.sh", headers = [] }
    pez_solutions     = { job = "pez.solutions", target = "https://pez.solutions", headers = [] }
    jellyfin          = { job = "jellyfin.pez.sh", target = "https://jellyfin.pez.sh", headers = [] }
    plex              = { job = "plex.pez.sh", target = "https://plex.pez.sh", headers = ["X-Plex-Token:${var.plex_token}"] }
    request           = { job = "request.pez.sh", target = "https://request.pez.sh", headers = [] }
    jellyfin_requests = { job = "jellyfin-requests.pez.sh", target = "https://jellyfin-requests.pez.sh", headers = [] }
    git               = { job = "git.pez.sh", target = "https://git.pez.sh", headers = [] }
  }
}

resource "grafana_synthetic_monitoring_check" "this" {
  for_each  = local.synthetic_checks
  job       = each.value.job
  target    = each.value.target
  enabled   = true
  probes    = [local.probe_london]
  frequency = local.check_frequency
  timeout   = local.check_timeout
  settings {
    http {
      method              = "GET"
      headers             = each.value.headers
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  lifecycle {
    ignore_changes = [settings]
  }
}

resource "grafana_synthetic_monitoring_check_alerts" "this" {
  for_each = grafana_synthetic_monitoring_check.this
  check_id = each.value.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}
