# proxmox

Provisions the Kubernetes cluster substrate on the **london-a** Proxmox node for
the [kube-proxmox](https://github.com/RWejlgaard/kube-proxmox) Flux cluster:

- a **control-plane VM** (`k3s-server`, `192.168.100.10`) — plain Debian; the
  Ansible `k3s_server` role installs k3s onto it.
- a **worker template** (`k3s-agent-template`) — cloned by
  [kproximate](https://github.com/lupinelab/kproximate); its cloud-init installs
  the k3s agent and joins the cluster on first boot.

## Required secrets

Add to `terraform/secrets.enc.yaml` (`sops terraform/secrets.enc.yaml`):

| Key | Value |
|-----|-------|
| `proxmox_api_token` | `root@pam!kube=<token-secret>` |
| `k3s_node_token`    | k3s agent join token (phase 2 — see below) |

The provider also SSHes to `root@london-a` (over Tailscale) to upload the
cloud-init snippet, so the apply environment needs that key in its agent.

## Two-phase bootstrap

The worker template bakes the k3s join token into cloud-init, but that token
only exists once the control plane is up:

1. **Phase 1** — apply with `k3s_node_token = ""`. Creates the control-plane VM
   and the (not-yet-joinable) template.
2. Run the Ansible `k3s_server` role; it installs k3s and writes the node token
   to SOPS.
3. **Phase 2** — set `k3s_node_token` and re-apply. The template is rebuilt with
   a working join script; kproximate clones from it.

## Notes

- Workers get addresses via **DHCP** on the cluster bridge — ensure the
  `192.168.100.0/24` segment has a DHCP range, or switch the template to static
  addressing managed by kproximate.
- `disk_datastore_id` defaults to `local-lvm` and `snippet_datastore_id` to
  `local`; override if london-a uses different storage (e.g. the `hdd` CIFS mount).
