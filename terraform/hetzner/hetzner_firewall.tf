locals {
  all_ips = ["0.0.0.0/0", "::/0"]

  machines = {
    "nuremberg-a" = {
      tcp_in    = ["22", "25", "80", "110", "143", "443", "465", "587", "993", "995"]
      server_id = hcloud_server.nuremberg-a.id
    }
    "helsinki-a" = {
      tcp_in    = ["22", "80", "443"]
      server_id = hcloud_server.helsinki-a.id
    }
  }
}

resource "hcloud_firewall" "machine" {
  for_each = local.machines
  name     = each.key

  dynamic "rule" {
    for_each = each.value.tcp_in
    content {
      direction  = "in"
      protocol   = "tcp"
      port       = rule.value
      source_ips = local.all_ips
    }
  }

  dynamic "rule" {
    for_each = ["tcp", "udp"]
    content {
      direction       = "out"
      protocol        = rule.value
      port            = "any"
      destination_ips = local.all_ips
    }
  }
}

resource "hcloud_firewall_attachment" "machine" {
  for_each    = local.machines
  firewall_id = hcloud_firewall.machine[each.key].id
  server_ids  = [each.value.server_id]
}
