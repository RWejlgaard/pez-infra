resource "hcloud_firewall" "nuremberg-a" {
  name = "nuremberg-a"

  rule {
    direction = "in"
    protocol  = "tcp"
    port = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  # poste.io mail server ports
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "110"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "143"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "465"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "587"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "993"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "995"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "out"
    protocol = "tcp"
    port = "any"
    destination_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
  }

  rule {
    direction = "out"
    protocol = "udp"
    port = "any"
    destination_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "nuremberg-a" {
    firewall_id = hcloud_firewall.nuremberg-a.id
    server_ids = [
        hcloud_server.nuremberg-a.id
    ]  
}

resource "hcloud_firewall" "helsinki-a" {
  name = "helsinki-a"

  rule {
    direction = "in"
    protocol  = "tcp"
    port = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "out"
    protocol = "tcp"
    port = "any"
    destination_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
  }

  rule {
    direction = "out"
    protocol = "udp"
    port = "any"
    destination_ips = [
        "0.0.0.0/0",
        "::/0"
    ]
  }
}

resource "hcloud_firewall_attachment" "helsinki-a" {
    firewall_id = hcloud_firewall.helsinki-a.id
    server_ids = [
        hcloud_server.helsinki-a.id
    ]  
}