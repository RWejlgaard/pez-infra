# london-a

VM host. Runs KVM virtual machines via Cockpit.

## Overview

| | |
|---|---|
| **Location** | London (NW9) |
| **OS** | Debian |
| **Tailscale IP** | 100.90.111.19 |
| **Role** | VM host (Cockpit + KVM) |

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel i7-4790K (8 threads) |
| Memory | 32 GB |
| Boot disk | 1 TB |

Old gaming PC. Reinstalled with Debian in 2026-05 after moving monitoring to Grafana Cloud.

## Services

| Service | Port | Status | Notes |
|---------|------|--------|-------|
| Cockpit | 9090 | Active | Web UI for VM management |
| cockpit-machines | — | Active | KVM/libvirt VM management via Cockpit |
| Tailscale | — | Active | Mesh networking |

## Networking

Connected via Cat 5 to the Ubiquiti switch alongside london-b.
