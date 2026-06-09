# Services

Complete map of every service in the fleet — what it does, where it runs, how it's deployed, and whether it's behind auth.

## helsinki-a — Gateway, Auth, Git

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Caddy | 80, 443 | Native (apt + systemd) | — | (reverse proxy, no direct URL) |
| Authelia | 9091 | Docker | — | auth.pez.sh |
| Authelia MariaDB | 3306 (internal) | Docker | — | (Authelia session/state) |
| LLDAP | 3890, 17170 | Docker | — | ldap.pez.sh (UI) — used by Authelia |
| Bitwarden (Vaultwarden) | 8443, 8080 | Docker | Own auth | bitwarden.pez.sh |
| Bitwarden MariaDB | 3306 (internal) | Docker | — | (Vaultwarden backing DB) |
| Forgejo | 3000 (HTTP), 2222 (SSH) | Docker | Own auth | git.pez.sh |
| Apps dashboard | — | Static (`/srv/apps`, Caddy) | Authelia | apps.pez.sh |

Caddy is the single entry point for all public traffic and runs as a native apt-managed systemd service so it can bind 80/443 directly. Everything else on this host runs in Docker.

Authelia provides SSO via Caddy `forward_auth`. LLDAP is Authelia's user backend — it is **not** wired into Forgejo or Bitwarden, both of which keep their own user databases. Bitwarden lives on helsinki-a so password management stays reachable even if the London servers are down. Forgejo hosts internal Git repositories and exposes SSH on port 2222 (the SSH service itself uses `git.pez.sh:2222`).

## london-b — Storage & Media

The workhorse. Threadripper 3970X, 64GB RAM. Everything media-related lives here.

### Media Servers

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Plex | 32400 | Native (apt/systemd) | Own auth | plex.pez.sh |
| Jellyfin | 8096 | Native (apt/systemd) | Own auth | jellyfin.pez.sh |
| Navidrome | 4533 | Docker | Own auth | music.pez.sh |

I run both Plex and Jellyfin — some clients work better with one than the other. Media is served directly from the ZFS pool.

### Media Automation (Arr Stack)

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Radarr | 7878 | Custom systemd unit (`/opt/Radarr`) | Authelia | radarr.pez.sh |
| Sonarr | 8989 | Native (apt/systemd, mono) | Authelia | sonarr.pez.sh |
| Lidarr | 8686 | Custom systemd unit (`/opt/Lidarr`) | Authelia | lidarr.pez.sh |
| Bookshelf | 8787 | Docker (`ghcr.io/pennydreadful/bookshelf`, Readarr revival) | Authelia | readarr.pez.sh |
| Prowlarr | 9696 | Custom systemd unit (`/opt/Prowlarr`) | Authelia | prowlarr.pez.sh |
| Whisparr | — | Custom systemd unit (disabled) | — | — |
| Transmission | 9091 | Native (apt/systemd) | Authelia | download.pez.sh |
| Jellyseerr | 5055 | Docker | Own auth | request.pez.sh |
| Overseerr | 5056 | Snap (`overseerr` from `latest/beta`) | Own auth | jellyfin-requests.pez.sh |

The arr stack pipeline: Jellyseerr/Overseerr accept requests → Radarr/Sonarr/Lidarr/Bookshelf search via Prowlarr → send to Transmission → downloaded content is moved to the library → Plex and Jellyfin pick it up automatically. Two requesters because Overseerr is hooked into Jellyfin and Jellyseerr into Plex.

### Other

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Nextcloud AIO | 11000 | Docker (manually managed via AIO mastercontainer — not in this repo) | Own auth | cloud.pez.sh (internal/Tailscale) |
| slskd (Soulseek) | 5030 | Docker | Authelia | soulseek.pez.sh |
| Syncthing (`syncthing@pez`) | 8384 | Native (apt) | Own auth | (LAN/Tailscale only) |
| Samba (`smbd`) | 445 | Native (apt) | Local users | (LAN/Tailscale only) |
| vsftpd | 21 | Native (apt) | Local users | (LAN/Tailscale only) |
| Ollama | 11434 | Native (`/usr/local/bin`) | — | (Tailscale only) |
| smartctl_exporter | 9633 | Docker | — | (scraped by Alloy → Grafana Cloud) |
| prom-plex-exporter | 9594 | Docker | — | (scraped by Alloy → Grafana Cloud) |

## london-a — Proxmox VE Hypervisor

Repurposed gaming PC (i7-4790K, 32 GB) running Proxmox VE on bare metal. Currently hosts a single Mac VM and is the landing zone for future virtual machines.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Proxmox VE | 8006 | Native (Debian Bookworm-based PVE) | Proxmox login | london-a.pez.sh |

The web UI is exposed via Caddy at `london-a.pez.sh` but is also reachable directly over Tailscale at `https://100.122.180.98:8006`. Proxmox storage is augmented with a CIFS share mounted from london-b's `/hdd/pve` for ISO/template/backup storage (configured by the `proxmox_ve` Ansible role).

## london-c — Edge Utility (Raspberry Pi)

Raspberry Pi running Debian 13. Houses helper services that don't need a beefy box.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| octopus_exporter | 9359 | Docker | — | (scraped by Alloy → Grafana Cloud) |

The `octopus_exporter` pulls electricity consumption data from the Octopus Energy API and exposes it as Prometheus-formatted metrics, which Alloy then ships to Grafana Cloud.

## nuremberg-a — Mail

Dedicated mail server on Hetzner Cloud. Isolated to protect IP reputation.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| poste.io | 25, 80, 110, 143, 443, 465, 587, 993, 995 | Docker | Own auth | (webmail via direct host access) |

poste.io bundles everything — postfix, dovecot, rspamd, webmail — into a single container. Makes updates straightforward.

## copenhagen-a — Gaming

Game servers. Not publicly exposed via Caddy — accessed directly over the public IP/Tailscale.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Minecraft (`itzg/minecraft-server`) | 25565 | Docker | — | (direct connection) |
| MaNGOS realmd | 3724 | Native (systemd) | — | (direct connection) |
| MaNGOS world | 8085 | Native (systemd) | — | (direct connection) |
| MariaDB | 3306 | Native (apt) | — | (local, used by MaNGOS) |
| smartctl_exporter | 9633 | Docker | — | (scraped by Alloy → Grafana Cloud) |

MaNGOS Zero is a WoW 1.12 (Vanilla) private server. Runs natively under systemd as the `mangos` user from `/home/mangos/mangos/zero/`. Not containerised — it predates the Docker setup on this host.

## copenhagen-c — Idle (Raspberry Pi)

Raspberry Pi running Debian 12 at the Copenhagen site. Mostly idle, but runs a cloudflared tunnel for one-off use.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| cloudflared | — | Native (systemd) | — | (Cloudflare-managed tunnel) |

## Observability Agents

Every host runs:

- **Grafana Alloy** (`alloy.service`) — collects metrics/logs/traces and ships them to Grafana Cloud
- **node_exporter** (`prometheus-node-exporter.service`) — host metrics (CPU/memory/disk/network)
- **systemd_exporter** (`systemd_exporter.service`) — per-unit systemd metrics

Plus host-specific exporters (smartctl, plex, octopus) called out above. See [monitoring.md](monitoring.md) for details on what gets shipped and where.

## Auth Summary

Services fall into two categories:

**Behind Authelia** (SSO via Caddy `forward_auth`):
- Radarr, Sonarr, Lidarr, Bookshelf, Prowlarr, Transmission, Soulseek, apps.pez.sh

**Own auth** (handle login themselves):
- Bitwarden, Forgejo, Plex, Jellyfin, Navidrome, Jellyseerr, Overseerr, Proxmox, poste.io
