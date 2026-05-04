resource "grafana_dashboard" "energy" {
  config_json = file("${path.module}/dashboards/energy.json")
}

resource "grafana_dashboard" "grafana_cloud_usage" {
  config_json = file("${path.module}/dashboards/grafana_cloud_usage.json")
}

resource "grafana_dashboard" "living_room_display" {
  config_json = file("${path.module}/dashboards/living_room_display.json")
}

resource "grafana_dashboard" "traffic_slo" {
  org_id      = 0
  config_json = file("${path.module}/dashboards/traffic_slo.json")
}
