resource "hcloud_server" "nuremberg-a" {
  name        = "nuremberg-a"
  image       = "debian-13"
  server_type = "cx23"

  location           = "nbg1"
  delete_protection  = true
  rebuild_protection = true
  keep_disk          = true

  labels = {
    "role" = "mail"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

resource "hcloud_server" "helsinki-a" {
  name        = "helsinki-a"
  image       = "debian-13"
  server_type = "cax11"

  location           = "hel1"
  delete_protection  = true
  rebuild_protection = true
  keep_disk          = true

  labels = {
    "role" = "ingress"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}

