# copenhagen-a

Game servers. Located at my dad's place in Copenhagen as an off-site location.

## Overview

| | |
|---|---|
| **Location** | Copenhagen |
| **OS** | Ubuntu 22.04 |
| **Tailscale IP** | 100.89.206.60 |
| **Role** | Gaming servers (Minecraft, WoW) |
| **Form factor** | Lenovo "tiny" desktop (lunchbox-sized) |

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel i5-4570T (4 threads) |
| Memory | 16 GB |
| Boot disk | 500 GB (26% used) |

Compact Lenovo desktop — powered by a standard ThinkPad charging brick. Small, quiet, and draws minimal power.

## Services

### Minecraft

| | |
|---|---|
| Image | `marctv/minecraft-papermc-server` |
| Port | 25565 |
| Deployment | Docker |

PaperMC for better performance than vanilla. Not proxied through Caddy — accessed directly via Tailscale or the host's IP.

### World of Warcraft (MaNGOS Zero)

WoW 1.12 (Vanilla) private server using the MaNGOS Zero emulator. Runs natively — not in Docker.

| Service | Port | Managed by |
|---------|------|-----------|
| mangos-realmd | 3724 | systemd |
| mangos-world | 8085 | systemd |
| MariaDB | 3306 | systemd (apt-managed) |

- Runs as the `mangos` user
- Install path: `/home/mangos/mangos/zero/`
- MariaDB hosts the character, world, and auth databases locally

Both `mangos-realmd` and `mangos-world` start automatically on boot via systemd.

### Cloudflare Tunnel

| | |
|---|---|
| Binary | `/usr/bin/cloudflared` |
| Managed by | systemd |
| Unit file | `ansible/services/systemd/copenhagen-a/cloudflared.service` |

Provides Cloudflare Tunnel access to the host. Token-based authentication configured directly in the systemd unit.

### Monitoring

| Service | Port | Managed by |
|---------|------|-----------|
| node_exporter | 9100 | systemd (Ansible-managed) |

Prometheus Node Exporter for host metrics. Installed and managed via the Ansible `node_exporter` role. Scraped by Prometheus on london-a via Tailscale.

> **Note:** Stale Docker images for `prom/node-exporter` and `quay.io/prometheus/node-exporter` exist on the host from a previous Docker-based deployment. These should be cleaned up — the systemd service is the active one.

### Potentially Unused Services

The following services are running but have no known active consumers:

| Service | Notes |
|---------|-------|
| PostgreSQL 14 | Only default databases (template0, template1, postgres). Likely leftover. |
| Redis 6.0 | Running but no known application depends on it. |

These are candidates for removal or investigation.

## Networking

Connected directly to the ISP router's built-in switch. Symmetrical 500 Mbit connection — more than enough for game servers.

## Notes

Copenhagen-a has a static IP, which is needed for game servers that require direct client connections (WoW realm list, Minecraft server list).
