module "hetzner" {
  source = "./hetzner"
  providers = {
    hcloud = hcloud
  }
}

module "grafana" {
  source = "./grafana"
  providers = {
    grafana = grafana
  }
  plex_token = local.secrets["plex_token"]
}
