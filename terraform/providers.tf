terraform {
  required_version = ">= 1.6.0"

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 4.35"
    }
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "~> 3.32"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
  }


  backend "s3" {
    bucket                      = "pez-infra-tfstate"
    key                         = "tfstate/terraform.tfstate"
    endpoints                   = { s3 = "s3.eu-central-003.backblazeb2.com" }
    region                      = "eu-central-003"
    skip_credentials_validation = true
    skip_region_validation      = true
    # NOTE: no state locking — Backblaze B2's S3 API doesn't implement the
    # conditional PutObject that OpenTofu's use_lockfile needs (returns 501
    # NotImplemented). Concurrent applies are instead prevented by the
    # `concurrency` guard in .github/workflows/terraform.yml.
    # Credentials read from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY env vars
  }
}

provider "hcloud" {
  token = local.secrets["hetzner_token"]
}

provider "grafana" {
  cloud_access_policy_token = local.secrets["grafana_cloud_access_policy"]
  sm_url                    = "https://synthetic-monitoring-api-gb-south-1.grafana.net"
  sm_access_token           = local.secrets["grafana_synthetic_monitoring_access_token"]
  fleet_management_url      = "https://fleet-management-prod-023.grafana.net"
  fleet_management_auth     = local.secrets["grafana_fleet_management_auth"]
  url                       = "https://pez.grafana.net"
  auth                      = local.secrets["grafana_service_account_token"]
}

provider "pagerduty" {
  token = local.secrets["pagerduty_token"]
}

provider "proxmox" {
  endpoint  = "https://100.122.180.98:8006/" # london-a over Tailscale
  api_token = local.secrets["proxmox_api_token"]
  insecure  = true # self-signed PVE cert

  # Uploading the cloud-init snippet needs node-level access; SSH to root@london-a.
  ssh {
    agent    = true
    username = "root"
  }
}
