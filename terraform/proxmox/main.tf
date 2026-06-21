# Debian cloud image, downloaded once onto the node and shared by both VMs.
resource "proxmox_download_file" "debian" {
  content_type = "import"
  datastore_id = var.snippet_datastore_id
  node_name    = var.node_name
  url          = var.debian_image_url
  file_name    = "debian-12-genericcloud-amd64.img"
}

# cloud-init user-data for autoscaled workers: install the k3s agent and join
# on first boot. kproximate clones the template below; nodes come up ready.
resource "proxmox_virtual_environment_file" "k3s_agent_init" {
  content_type = "snippets"
  datastore_id = var.snippet_datastore_id
  node_name    = var.node_name

  source_raw {
    file_name = "k3s-agent-init.yaml"
    data      = <<-EOT
      #cloud-config
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - systemctl enable --now qemu-guest-agent
        - curl -sfL https://get.k3s.io | K3S_URL=${var.k3s_url} K3S_TOKEN=${var.k3s_node_token} sh -s - agent
    EOT
  }
}

# Control-plane VM. Plain Debian + cloud-init; the k3s server itself is
# installed by the Ansible `k3s_server` role, not here.
resource "proxmox_virtual_environment_vm" "k3s_server" {
  name      = "k3s-server"
  node_name = var.node_name
  vm_id     = var.control_plane_vm_id
  tags      = ["k8s", "control-plane"]

  agent {
    enabled = true
  }

  cpu {
    cores = var.control_plane_cores
    type  = "host"
  }

  memory {
    dedicated = var.control_plane_memory
  }

  disk {
    datastore_id = var.disk_datastore_id
    import_from  = proxmox_download_file.debian.id
    interface    = "scsi0"
    size         = 30
  }

  network_device {
    bridge = var.network_bridge
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = var.disk_datastore_id

    ip_config {
      ipv4 {
        address = "${var.control_plane_ip}/24"
        gateway = var.subnet_gateway
      }
    }

    user_account {
      username = "debian"
      keys     = var.ssh_authorized_keys
    }
  }
}

# Worker template — kproximate clones this. Not started; cloud-init join script
# runs on the clones. DHCP on the cluster bridge assigns their addresses.
resource "proxmox_virtual_environment_vm" "k3s_agent_template" {
  name      = "k3s-agent-template"
  node_name = var.node_name
  vm_id     = var.worker_template_vm_id
  template  = true
  started   = false
  tags      = ["k8s", "worker", "template"]

  agent {
    enabled = true
  }

  cpu {
    cores = var.worker_cores
    type  = "host"
  }

  memory {
    dedicated = var.worker_memory
  }

  disk {
    datastore_id = var.disk_datastore_id
    import_from  = proxmox_download_file.debian.id
    interface    = "scsi0"
    size         = 40
  }

  network_device {
    bridge = var.network_bridge
  }

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id      = var.disk_datastore_id
    user_data_file_id = proxmox_virtual_environment_file.k3s_agent_init.id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "debian"
      keys     = var.ssh_authorized_keys
    }
  }
}
