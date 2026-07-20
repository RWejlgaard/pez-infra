resource "grafana_fleet_management_collector" "london_a" {
  id = "london-a"
  remote_attributes = {
    location = "london"
  }
}

resource "grafana_fleet_management_collector" "london_b" {
  id = "london-b"
  remote_attributes = {
    location = "london"
  }
}

resource "grafana_fleet_management_collector" "london_c" {
  id = "london-c"
  remote_attributes = {
    location = "london"
  }
}

resource "grafana_fleet_management_collector" "helsinki_a" {
  id = "helsinki-a"
  remote_attributes = {
    location = "cloud"
  }
}

resource "grafana_fleet_management_collector" "nuremberg_a" {
  id = "nuremberg-a"
  remote_attributes = {
    location = "cloud"
  }
}
