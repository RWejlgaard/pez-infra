# copenhagen-a

Proxmox VE hypervisor. Located at my dad's place in Copenhagen as an off-site location — the Copenhagen counterpart to london-a.

## Overview

| | |
|---|---|
| **Location** | Copenhagen |
| **OS** | Debian 12 (Bookworm) with Proxmox VE |
| **Tailscale IP** | 100.91.240.29 |
| **Role** | Hypervisor (Proxmox VE) |
| **Form factor** | Lenovo "tiny" desktop (lunchbox-sized) |

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel i5-4570T (4 threads) |
| Memory | 16 GB |
| Boot disk | 500 GB |

Compact Lenovo desktop — powered by a standard ThinkPad charging brick. Small, quiet, and draws minimal power. Previously ran the gaming servers directly on bare metal; now repaved as a Proxmox VE host.

## Services

| Service | Port | Status | Notes |
|---------|------|--------|-------|
| Proxmox VE | 8006 | Active | Web UI — reachable via `copenhagen-a.pez.sh` (Caddy) or Tailscale IP |
| Tailscale | — | Active | Mesh networking |
| node_exporter, systemd_exporter, Alloy | — | Active | Observability baseline (Ansible-managed) |

### Storage

Proxmox is connected to the same CIFS share on **london-b** (`100.84.65.101 /pve`) used by london-a, for ISO/template/backup storage. The mount is configured by the `proxmox_ve` Ansible role.

| Storage ID | Type | Backing |
|---|---|---|
| `local-lvm` | LVM-Thin | Local boot disk |
| `hdd` | CIFS | london-b `/pve` share |

### VMs

No VMs provisioned yet — this is the landing zone for future workloads at the Copenhagen site.

## Ansible

Part of the `proxmox_hosts` group alongside london-a, sharing the `proxmox_ve` role:

- Swaps the enterprise apt repo for `pve-no-subscription` so updates work without a paid subscription
- Patches `proxmoxlib.js` to suppress the subscription nag dialog
- Restricts the web UI to the `tailscale0` interface via UFW
- Mounts the london-b CIFS storage

## Networking

Connected directly to the ISP router's built-in switch. Symmetrical 500 Mbit connection.

## History

copenhagen-a used to run gaming servers directly on bare metal: a Minecraft server (`itzg/minecraft-server`, Docker) and a WoW 1.12 (Vanilla) MaNGOS Zero private server (native systemd + local MariaDB). Both were decommissioned and the host was repaved as Proxmox VE — the Tailscale identity (and IP) changed as part of the reinstall. The old static public IP used for direct game-client connections (Minecraft server list, WoW realm list) is no longer needed since nothing here accepts direct client connections anymore.
