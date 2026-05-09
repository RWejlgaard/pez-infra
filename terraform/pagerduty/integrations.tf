resource "pagerduty_service_integration" "grafana_cloud" {
  name    = "Grafana"
  service = pagerduty_service.pez_solutions.id
  vendor  = ""
}

output "pagerduty_integration_key" {
  value = pagerduty_service_integration.grafana_cloud.integration_key
}
