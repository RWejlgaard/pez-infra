locals {
  fleet_pipelines = {
    caddy_tracing = {
      matchers = ["collector.ID=\"helsinki-a\""]
    }
    linux_node_linux = {
      matchers = ["collector.os=\"linux\""]
    }
    octopus_exporter = {
      matchers = ["collector.ID=\"london-c\""]
    }
    plex = {
      matchers = ["collector.ID=\"london-b\""]
    }
    caddy_linux = {
      matchers = ["collector.ID=\"helsinki-a\""]
    }
    docker_linux = {
      matchers = ["collector.os=\"linux\""]
    }
  }
}

resource "grafana_fleet_management_pipeline" "this" {
  for_each = local.fleet_pipelines

  name     = each.key
  matchers = each.value.matchers
  contents = file("${path.module}/fleet_pipelines/${each.key}.alloy")
}

