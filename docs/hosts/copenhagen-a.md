# copenhagen-a

Game servers. Located at my dad's place in Copenhagen as an off-site location.

## Overview

| | |
|---|---|
| **Location** | Copenhagen |
| **OS** | Ubuntu 22.04 LTS |
| **Tailscale IP** | 100.89.206.60 |
| **Role** | Gaming servers (Minecraft, WoW) |
| **Form factor** | Lenovo "tiny" desktop (lunchbox-sized) |

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel i5-4570T (4 threads) |
| Memory | 16 GB |
| Boot disk | 500 GB |

Compact Lenovo desktop — powered by a standard ThinkPad charging brick. Small, quiet, and draws minimal power.

## Services

### Minecraft

| | |
|---|---|
| Image | `itzg/minecraft-server` |
| Port | 25565 |
| Deployment | Docker |

Not proxied through Caddy — accessed directly via Tailscale or the host's public IP.

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
- Both `mangos-realmd` and `mangos-world` start automatically on boot via systemd
- The `mariadb` Ansible role manages package + secrets; the `systemd_services` role drops the unit files (`ansible/services/mangos-realmd/`, `ansible/services/mangos-world/`)

### Other

| Service | Port | Deployment | Notes |
|---------|------|-----------|-------|
| smartctl_exporter | 9633 | Docker | Disk SMART metrics scraped by Alloy |
| node_exporter | 9100 | Native | Host metrics |
| systemd_exporter | — | Native | systemd unit metrics |
| Alloy | — | Native | Ships everything to Grafana Cloud |
| Tailscale | — | Native | Mesh networking |

## Networking

Connected directly to the ISP router's built-in switch. Symmetrical 500 Mbit connection — more than enough for game servers.

## Notes

copenhagen-a has a static public IP, which is needed for game servers that require direct client connections (WoW realm list, Minecraft server list). The reboot playbook (`ansible/playbooks/reboot.yml`) does a netplan pre-flight check before rebooting to make sure the static IP config will come back up cleanly.
