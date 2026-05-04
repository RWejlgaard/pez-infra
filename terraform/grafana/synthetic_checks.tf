resource "grafana_synthetic_monitoring_check" "pez_sh" {
  job     = "pez.sh"
  target  = "https://pez.sh"
  enabled = true
  probes  = [14] # 14 = London, UK
  settings {
    http {
      method              = "GET"
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  frequency = 600000
  timeout   = 3000
  lifecycle {
    ignore_changes = [settings]
  }
}

resource "grafana_synthetic_monitoring_check" "pez_solutions" {
  job     = "pez.solutions"
  target  = "https://pez.solutions"
  enabled = true
  probes  = [14] # 14 = London, UK
  settings {
    http {
      method              = "GET"
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  frequency = 600000
  timeout   = 3000
  lifecycle {
    ignore_changes = [settings]
  }
}

resource "grafana_synthetic_monitoring_check" "jellyfin" {
  job     = "jellyfin.pez.sh"
  target  = "https://jellyfin.pez.sh"
  enabled = true
  probes  = [14] # 14 = London, UK
  settings {
    http {
      method              = "GET"
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  frequency = 600000
  timeout   = 3000
  lifecycle {
    ignore_changes = [settings]
  }
}

resource "grafana_synthetic_monitoring_check" "plex" {
  job     = "plex.pez.sh"
  target  = "https://plex.pez.sh"
  enabled = true
  probes  = [14] # 14 = London, UK
  settings {
    http {
      method              = "GET"
      headers             = ["X-Plex-Token:${var.plex_token}"]
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  frequency = 600000
  timeout   = 3000
  lifecycle {
    ignore_changes = [settings]
  }
}

resource "grafana_synthetic_monitoring_check" "request" {
  job     = "request.pez.sh"
  target  = "https://request.pez.sh"
  enabled = true
  probes  = [14] # 14 = London, UK
  settings {
    http {
      method              = "GET"
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  frequency = 600000
  timeout   = 3000
  lifecycle {
    ignore_changes = [settings]
  }
}

resource "grafana_synthetic_monitoring_check" "jellyfin-requests" {
  job     = "jellyfin-requests.pez.sh"
  target  = "https://jellyfin-requests.pez.sh"
  enabled = true
  probes  = [14] # 14 = London, UK
  settings {
    http {
      method              = "GET"
      compression         = "none"
      fail_if_not_ssl     = true
      ip_version          = "V4"
      valid_http_versions = ["HTTP/2.0", "HTTP/1.1", "HTTP/1.0"]
      valid_status_codes  = ["200"]
    }
  }
  frequency = 600000
  timeout   = 3000
  lifecycle {
    ignore_changes = [settings]
  }
}
