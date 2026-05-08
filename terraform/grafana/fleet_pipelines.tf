locals {
  fleet_pipelines = {
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

import {
  to = module.grafana.grafana_fleet_management_pipeline.this["linux_node_linux"]
  id = "linux_node_linux"
}

import {
  to = module.grafana.grafana_fleet_management_pipeline.this["octopus_exporter"]
  id = "octopus_exporter"
}

import {
  to = module.grafana.grafana_fleet_management_pipeline.this["plex"]
  id = "plex"
}

import {
  to = module.grafana.grafana_fleet_management_pipeline.this["caddy_linux"]
  id = "caddy_linux"
}

import {
  to = module.grafana.grafana_fleet_management_pipeline.this["docker_linux"]
  id = "docker_linux"
}