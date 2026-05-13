# london-a

Proxmox VE hypervisor.

## Overview

| | |
|---|---|
| **Location** | London (NW9) |
| **OS** | Proxmox VE (Debian Bookworm) |
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
| Proxmox VE | 8006 | Active | Web UI — Tailscale only |
| Tailscale | — | Active | Mesh networking |

## Networking

Connected via Cat 5 to the Ubiquiti switch alongside london-b.
