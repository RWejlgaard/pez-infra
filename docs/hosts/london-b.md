# london-b

Primary storage and media server. The workhorse of the fleet.

## Overview

| | |
|---|---|
| **Location** | London (NW9) |
| **OS** | Ubuntu 24.04 |
| **Tailscale IP** | 100.84.65.101 |
| **Role** | Storage, media serving, Docker services |

## Hardware

| Component | Spec |
|---|---|
| CPU | AMD Threadripper 3970X (64 threads) |
| Memory | 64 GB |
| GPU | Nvidia GTX 980 |
| Boot disk | 500 GB |
| Storage pool | ~87 TB raw / ~64 TB usable (ZFS) |

This machine is ridiculously overpowered as a media server. It's my old gaming/workstation PC repurposed into server duty. The GPU helps with Plex transcoding but the CPU can handle it fine on its own.

## Storage

ZFS pool `hdd`: 3× RAIDZ1 vdevs, 4 drives each (12 drives total).

| Metric | Value |
|---|---|
| Used | ~61 TB |
| Free | ~26 TB |
| Total | ~87 TB raw |
| Usage | ~70% |
| Scrub | Weekly (Sundays at 12:00, cron `/sbin/zpool scrub hdd`) |

RAIDZ1 tolerates one drive failure per vdev. With this many drives and this much data, ZFS checksumming is essential — silent data corruption on spinning disks is real and you don't want to find out about it years later.

**Roadmap:** the long-term plan is to gradually replace the 8 TB drives with 24 TB drives and grow the pool toward 24 drives / ~0.5 PB raw.

## Services

### Media Servers

| Service | Port | URL |
|---------|------|-----|
| Plex | 32400 | plex.pez.sh |
| Jellyfin | 8096 | jellyfin.pez.sh |
| Navidrome | 4533 | music.pez.sh |

### Media Automation

| Service | Port | URL |
|---------|------|-----|
| Radarr | 7878 | radarr.pez.sh |
| Sonarr | 8989 | sonarr.pez.sh |
| Lidarr | 8686 | lidarr.pez.sh |
| Bookshelf (Readarr revival, Docker) | 8787 | readarr.pez.sh |
| Prowlarr | 9696 | prowlarr.pez.sh |
| Transmission | 9091 | download.pez.sh |
| Jellyseerr | 5055 | request.pez.sh |
| Overseerr (snap) | 5056 | jellyfin-requests.pez.sh |

### Other

| Service | Port | URL |
|---------|------|-----|
| Nextcloud AIO | 11000 | cloud.pez.sh (internal) |
| slskd (Soulseek) | 5030 | soulseek.pez.sh |
| Syncthing (`syncthing@pez`) | 8384 | (LAN / Tailscale) |
| Ollama | 11434 | (Tailscale) |
| smartctl_exporter | 9633 | (Alloy scrape) |
| prom-plex-exporter | 9594 | (Alloy scrape) |

### Systemd Services (non-Docker)

The media automation suite and several supporting services run as native systemd units, not in Docker:

| Service | Unit Name | Notes |
|---------|-----------|-------|
| Sonarr | sonarr | Package-managed (mono) |
| Radarr | radarr | /opt/Radarr, custom unit |
| Prowlarr | prowlarr | /opt/Prowlarr, custom unit |
| Lidarr | lidarr | /opt/Lidarr, custom unit |
| Whisparr | whisparr | /opt/Whisparr, custom unit (disabled) |
| Plex | plexmediaserver | Package-managed |
| Jellyfin | jellyfin | Package-managed |
| Transmission | transmission-daemon | Package-managed |
| Samba | smbd | Package-managed |
| Ollama | ollama | /usr/local/bin, custom unit |
| Syncthing | syncthing@pez | Package-managed, user instance |
| vsftpd | vsftpd | FTP server for /hdd/ftp |
| systemd_exporter | systemd_exporter | Ansible-managed |
| node_exporter | prometheus-node-exporter | apt-managed |
| Alloy | alloy | Grafana Alloy, fleet-managed config |

Docker services: Nextcloud AIO (manually managed via AIO mastercontainer, not in this repo), Jellyseerr, Navidrome, slskd, smartctl-exporter, plex-exporter.

Snap: Overseerr (`latest/beta` channel).

### Cron Jobs

| Schedule | Job |
|----------|-----|
| Every hour | `/root/scripts/movie-rename-fix.fish` |
| Midnight daily | `systemctl restart radarr` |
| Midnight daily | `systemctl restart sonarr` |
| 22:00 daily | `/root/scripts/backup.sh` (rclone to Backblaze B2) |
| Sundays 12:00 | `/sbin/zpool scrub hdd` |

### Samba Shares

| Share | Path | Access |
|-------|------|--------|
| HDD | /hdd | pez, root (rw) |
| Movies | /hdd/movies | public (ro) |
| TV Shows | /hdd/tv | public (ro) |
| pve | /hdd/pve | london-a Proxmox (rw) — ISO/template/backup storage |

Media is served directly from the ZFS pool. Docker root (`/hdd/docker`) and PVE storage (`/hdd/pve`) live on the pool too.

## Networking

Connected via Cat 5 to the Ubiquiti switch in the utility closet. 1 Gbit LAN connection.
