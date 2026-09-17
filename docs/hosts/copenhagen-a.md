# copenhagen-a

Proxmox VE hypervisor. Located at my dad's place in Copenhagen as an off-site location — the Copenhagen counterpart to london-a.

## Overview

| | |
|---|---|
| **Location** | Copenhagen |
| **OS** | Debian 13 (Trixie) with Proxmox VE |
| **Tailscale IP** | 100.91.240.29 |
| **Role** | Hypervisor (Proxmox VE) |
| **Form factor** | Minisforum MS-A2 mini PC |

## Hardware

| Component | Spec |
|---|---|
| CPU | AMD Ryzen 9 9955HX (16 cores / 32 threads) |
| Memory | 64 GB |
| Boot disk | 1 TB NVMe (Kingston OM8TAP41024K1-A00) |

Minisforum MS-A2 mini PC. Small, quiet, and draws minimal power relative to its performance. This replaced the original Lenovo "tiny" desktop (Intel i5-4570T / 16 GB / 500 GB) that used to run the gaming servers directly on bare metal; the host was repaved as Proxmox VE on the new hardware.

## Services

| Service | Port | Status | Notes |
|---------|------|--------|-------|
| Proxmox VE | 8006 | Active | Web UI — reachable via `copenhagen-a.pez.sh` (Caddy) or Tailscale IP |
| Tailscale | — | Active | Mesh networking |
| node_exporter, systemd_exporter, Alloy | — | Active | Observability baseline (Ansible-managed) |

### Storage

Unlike london-a, this host does **not** mount london-b's `/pve` CIFS share — it's not worth the WAN/Tailscale hop from Copenhagen for VM storage. It does use london-b for backups (below). Only local storage is configured (`proxmox_ve_mount_cifs_storage: false` in `host_vars/copenhagen-a.yml`).

| Storage ID | Type | Backing |
|---|---|---|
| `local-lvm` | LVM-Thin | Local boot disk |
| `local` | Directory | ISO/template storage |
| `london-b-backups` | CIFS | london-b `pve-backups` share over Tailscale, `/copenhagen-a` subdir — backups only |

### Backups

There's no room for backups locally, so they go to london-b over Tailscale. Every vzdump run is a full archive, so only the VMs that change daily run nightly. Jobs are defined in `proxmox_ve_backup_jobs` in `host_vars/copenhagen-a.yml`:

| Job | Schedule | VMs | Retention |
|---|---|---|---|
| `daily` | 03:00 | 100 (k8s-control-plane), 102 (minecraft), 103 (mangos-zero) | 7 daily, 4 weekly |
| `weekly` | Sun 04:30 | 101 (workspace), 104 (workspace-alpine) | 4 weekly |

### VMs

Runs a mix of always-on VMs (Kubernetes control plane, a general-purpose workspace, Minecraft) plus Karpenter-managed Kubernetes worker nodes that scale up/down on demand.

## Ansible

Part of the `proxmox_hosts` group alongside london-a, sharing the `proxmox_ve` role:

- Swaps the enterprise apt repo for `pve-no-subscription` so updates work without a paid subscription
- Patches `proxmoxlib.js` to suppress the subscription nag dialog
- Restricts the web UI to the `tailscale0` interface via UFW
- Skips the london-b `/pve` CIFS mount (`proxmox_ve_mount_cifs_storage: false`)
- Adds the `london-b-backups` storage and reconciles the vzdump jobs in `proxmox_ve_backup_jobs`

## Networking

Connected directly to the ISP router's built-in switch. Symmetrical 500 Mbit connection.

## History

copenhagen-a used to run gaming servers directly on bare metal: a Minecraft server (`itzg/minecraft-server`, Docker) and a WoW 1.12 (Vanilla) MaNGOS Zero private server (native systemd + local MariaDB). Both were decommissioned and the host was repaved as Proxmox VE — the Tailscale identity (and IP) changed as part of the reinstall. The old static public IP used for direct game-client connections (Minecraft server list, WoW realm list) is no longer needed since nothing here accepts direct client connections anymore.
