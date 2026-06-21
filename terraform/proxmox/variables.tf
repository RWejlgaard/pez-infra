variable "node_name" {
  description = "Proxmox node hosting the cluster."
  type        = string
  default     = "london-a"
}

variable "disk_datastore_id" {
  description = "Datastore for VM disks."
  type        = string
  default     = "local-lvm"
}

variable "snippet_datastore_id" {
  description = "Datastore that holds cloud-init snippets (must allow 'snippets' content)."
  type        = string
  default     = "local"
}

variable "network_bridge" {
  description = "Proxmox bridge on the 192.168.100.0/24 cluster subnet."
  type        = string
  default     = "vmbr0"
}

variable "subnet_gateway" {
  description = "Gateway for the cluster subnet."
  type        = string
  default     = "192.168.100.1"
}

variable "debian_image_url" {
  description = "Cloud image used for the control plane and the worker template."
  type        = string
  default     = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
}

variable "ssh_authorized_keys" {
  description = "Public keys injected into the cloud-init default user."
  type        = list(string)
  default     = []
}

# --- Control plane (Ansible installs k3s server onto this VM) ---
variable "control_plane_vm_id" {
  type    = number
  default = 9000
}

variable "control_plane_ip" {
  description = "Static IP (without CIDR) for the k3s control plane."
  type        = string
  default     = "192.168.100.10"
}

variable "control_plane_cores" {
  type    = number
  default = 2
}

variable "control_plane_memory" {
  type    = number
  default = 4096
}

# --- Worker template (kproximate clones this; cloud-init auto-joins k3s) ---
variable "worker_template_vm_id" {
  type    = number
  default = 9001
}

variable "worker_cores" {
  type    = number
  default = 4
}

variable "worker_memory" {
  type    = number
  default = 8192
}

variable "k3s_url" {
  description = "API endpoint workers join (control plane :6443)."
  type        = string
  default     = "https://192.168.100.10:6443"
}

variable "k3s_node_token" {
  description = <<-EOT
    k3s agent join token. Empty on the first apply (control plane doesn't exist
    yet); after Ansible installs k3s and writes the token to SOPS, set this and
    re-apply so the worker template can auto-join. See module README.
  EOT
  type        = string
  default     = ""
  sensitive   = true
}
