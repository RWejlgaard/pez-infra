# Services

Complete map of every service in the fleet — what it does, where it runs, how it's deployed, and whether it's behind auth.

## helsinki-a — Gateway & Auth

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Caddy | 80, 443 | Docker | — | (reverse proxy, no direct URL) |
| Authelia | 9091 | Docker | — | auth.pez.sh |
| Bitwarden (Vaultwarden) | 8443 | Docker | Own auth | bitwarden.pez.sh |
| LLDAP | 3890/17170 | Docker | — | (internal, used by Authelia) |

Caddy is the single entry point for all public traffic. Authelia and LLDAP provide SSO. Bitwarden is on helsinki-a for availability — it needs to be reachable even if the London servers are down.

## london-b — Storage & Media

The workhorse. Threadripper 3970X, 64GB RAM, 64TB ZFS storage. Everything media-related lives here.

### Media Servers

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Plex | 32400 | Docker | Own auth | plex.pez.sh |
| Jellyfin | 8096 | Docker | Own auth | jellyfin.pez.sh |
| Navidrome | 4533 | Docker | Own auth | music.pez.sh |

I run both Plex and Jellyfin — some clients work better with one than the other. Media is served directly from the ZFS pool.

### Media Automation (Arr Stack)

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Radarr | 7878 | Docker | Authelia | radarr.pez.sh |
| Sonarr | 8989 | Docker | Authelia | sonarr.pez.sh |
| Lidarr | 8686 | Docker | Authelia | lidarr.pez.sh |
| Readarr | 8787 | Docker | Authelia | readarr.pez.sh |
| Prowlarr | 9696 | Docker | Authelia | prowlarr.pez.sh |
| Transmission | 9091 | Docker | Authelia | download.pez.sh |
| Jellyseerr | 5055 | Docker | Own auth | request.pez.sh |

The arr stack pipeline: Jellyseerr accepts requests → Radarr/Sonarr/Lidarr/Readarr search via Prowlarr → sends to Transmission → downloaded content is moved to the library → Plex and Jellyfin pick it up automatically.

### Other

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Nextcloud AIO | 11000 | Docker | Own auth | cloud.pez.sh |
| slskd (Soulseek) | 5030 | Docker | Authelia | soulseek.pez.sh |
| smartctl exporter | 9633 | Docker | — | (scraped by Prometheus) |
| prom-plex-exporter | — | Docker | — | (scraped by Prometheus) |

## london-a — Monitoring

Dedicated monitoring host running FreeBSD. Very lightly loaded.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Prometheus | 9090 | Native | Authelia | prometheus.pez.sh |
| Grafana | 3000 | Native | Authelia | grafana.pez.sh |

See [monitoring.md](monitoring.md) for details on scrape targets, dashboards, and exporters.

## nuremberg-a — Mail

Dedicated mail server on Hetzner Cloud. Isolated to protect IP reputation.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| poste.io | 25, 587, 993, 443 | Docker | Own auth | (webmail via direct access) |

poste.io bundles everything — postfix, dovecot, rspamd, webmail — into a single container. Makes updates straightforward.

## copenhagen-a — Gaming

Game servers. Not publicly exposed via Caddy — accessed directly or over Tailscale.

| Service | Port | Deployment | Auth | URL |
|---------|------|-----------|------|-----|
| Minecraft (PaperMC) | 25565 | Docker | — | (direct connection) |
| MaNGOS realmd | 3724 | Native (systemd) | — | (direct connection) |
| MaNGOS world | 8085 | Native (systemd) | — | (direct connection) |
| MariaDB | 3306 | Native | — | (local, used by MaNGOS) |

MaNGOS Zero is a WoW 1.12 (Vanilla) private server. Runs natively under systemd as the `mangos` user from `/home/mangos/mangos/zero/`. Not containerised — it predates the Docker setup on this host.

## copenhagen-c — Idle

No active services. Available for future use.

## Exporters (Monitoring)

These run on various hosts and are scraped by Prometheus:

| Exporter | Host | What it monitors |
|----------|------|-----------------|
| node_exporter | All hosts | CPU, memory, disk, network |
| smartctl_exporter | london-b | Disk SMART health data |
| prom-plex-exporter | london-b | Plex activity metrics |

## Auth Summary

Services fall into two categories:

**Behind Authelia** (SSO via Caddy forward_auth):
- Grafana, Prometheus, Radarr, Sonarr, Lidarr, Readarr, Prowlarr, Transmission, Soulseek, apps.pez.sh

**Own auth** (handle login themselves):
- Bitwarden, Plex, Jellyfin, Nextcloud, Navidrome, Jellyseerr, poste.io
