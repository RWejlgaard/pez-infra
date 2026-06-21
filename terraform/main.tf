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

module "pagerduty" {
  source = "./pagerduty"
  providers = {
    pagerduty = pagerduty
  }
}

module "proxmox" {
  source = "./proxmox"
  providers = {
    proxmox = proxmox
  }
  ssh_authorized_keys = [local.personal_ssh_public_key]
  # Empty until the control plane's k3s server is installed (see proxmox/README).
  k3s_node_token = try(local.secrets["k3s_node_token"], "")
}
