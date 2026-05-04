resource "grafana_fleet_management_pipeline" "linux_node_linux" {
  name     = "linux_node_linux"
  matchers = ["collector.os=\"linux\""]
  contents = file("${path.module}/fleet_pipelines/linux_node_linux.alloy")
}

resource "grafana_fleet_management_pipeline" "octopus_exporter" {
  name     = "octopus_exporter"
  matchers = ["collector.ID=\"london-c\""]
  contents = file("${path.module}/fleet_pipelines/octopus_exporter.alloy")
}

resource "grafana_fleet_management_pipeline" "plex" {
  name     = "plex"
  matchers = ["collector.ID=\"london-b\""]
  contents = file("${path.module}/fleet_pipelines/plex.alloy")
}

resource "grafana_fleet_management_pipeline" "caddy_linux" {
  name     = "caddy_linux"
  matchers = ["collector.ID=\"helsinki-a\""]
  contents = file("${path.module}/fleet_pipelines/caddy_linux.alloy")
}

resource "grafana_fleet_management_pipeline" "docker_linux" {
  name     = "docker_linux"
  matchers = ["collector.os=\"linux\""]
  contents = file("${path.module}/fleet_pipelines/docker_linux.alloy")
}
