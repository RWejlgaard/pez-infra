resource "grafana_synthetic_monitoring_check_alerts" "pez_sh" {
  check_id = grafana_synthetic_monitoring_check.pez_sh.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}

resource "grafana_synthetic_monitoring_check_alerts" "pez_solutions" {
  check_id = grafana_synthetic_monitoring_check.pez_solutions.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}

resource "grafana_synthetic_monitoring_check_alerts" "jellyfin" {
  check_id = grafana_synthetic_monitoring_check.jellyfin.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}

resource "grafana_synthetic_monitoring_check_alerts" "plex" {
  check_id = grafana_synthetic_monitoring_check.plex.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}

resource "grafana_synthetic_monitoring_check_alerts" "request" {
  check_id = grafana_synthetic_monitoring_check.request.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}

resource "grafana_synthetic_monitoring_check_alerts" "jellyfin-requests" {
  check_id = grafana_synthetic_monitoring_check.jellyfin-requests.id
  alerts = [
    {
      name        = "ProbeFailedExecutionsTooHigh"
      threshold   = 3
      period      = "30m"
      runbook_url = ""
    }
  ]
}

