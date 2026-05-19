# london-a

Proxmox VE hypervisor. The platform for any VM workloads I want to run on owned hardware.

## Overview

| | |
|---|---|
| **Location** | London (NW9) |
| **OS** | Debian 13 (Trixie) with Proxmox VE 9.x |
| **Tailscale IP** | 100.122.180.98 |
| **Role** | Hypervisor (Proxmox VE) |

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel i7-4790K (8 threads) |
| Memory | 32 GB |
| Boot disk | 1 TB |

Old gaming PC. Runs Proxmox VE on bare metal.

## Services

| Service | Port | Status | Notes |
|---------|------|--------|-------|
| Proxmox VE | 8006 | Active | Web UI — reachable via `london-a.pez.sh` (Caddy) or Tailscale IP |
| Tailscale | — | Active | Mesh networking |
| node_exporter, systemd_exporter, Alloy | — | Active | Observability baseline (Ansible-managed) |

### Storage

Proxmox is connected to a CIFS share on **london-b** (`100.84.65.101 /pve`) for ISO/template/backup storage. The mount is configured by the `proxmox_ve` Ansible role:

| Storage ID | Type | Backing |
|---|---|---|
| `local-lvm` | LVM-Thin | Local boot disk |
| `hdd` | CIFS | london-b `/pve` share |

### VMs

| VMID | Name | Status | Notes |
|---|---|---|---|
| 100 | Mac-Server | Stopped | macOS Sequoia VM (OpenCore bootloader). Intended for occasional macOS workloads. |

The VM list will grow over time — this is a general-purpose hypervisor, not a single-VM appliance.

## Ansible

The `proxmox_ve` role:

- Swaps the enterprise apt repo for `pve-no-subscription` so updates work without a paid subscription
- Patches `proxmoxlib.js` to suppress the subscription nag dialog
- Restricts the web UI to the `tailscale0` interface via UFW
- Mounts the london-b CIFS storage

## Networking

Connected via Cat 5 to the Ubiquiti switch alongside london-b and london-c.

## History

london-a used to run **FreeBSD** as a single-purpose monitoring host (Prometheus + Grafana). Monitoring moved to Grafana Cloud, the box was repaved as Proxmox VE, and the FreeBSD-specific Ansible has been removed.
