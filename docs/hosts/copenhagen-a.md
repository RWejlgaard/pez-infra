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
| MariaDB | 3306 | systemd |

- Runs as the `mangos` user
- Install path: `/home/mangos/mangos/zero/`
- MariaDB hosts the character, world, and auth databases locally

Both `mangos-realmd` and `mangos-world` start automatically on boot via systemd.

## Networking

Connected directly to the ISP router's built-in switch. Symmetrical 500 Mbit connection — more than enough for game servers.

## Notes

Copenhagen-a has a static IP, which is needed for game servers that require direct client connections (WoW realm list, Minecraft server list).
