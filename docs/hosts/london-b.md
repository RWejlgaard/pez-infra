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
| Storage pool | ~64 TB (ZFS) |

This machine is ridiculously overpowered as a media server. It's my old gaming/workstation PC repurposed into server duty. The GPU helps with Plex transcoding but the CPU can handle it fine on its own.

## Storage

ZFS pool `hdd`: 3× RAIDZ1 vdevs, 8 drives total.

| Metric | Value |
|---|---|
| Used | 46 TB |
| Free | 18 TB |
| Total | ~64 TB |
| Usage | 72% |
| Scrub | Weekly (Sundays) |

RAIDZ1 tolerates one drive failure per vdev. With this many drives and this much data, ZFS checksumming is essential — silent data corruption on spinning disks is real and you don't want to find out about it years later.

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
| Readarr | 8787 | readarr.pez.sh |
| Prowlarr | 9696 | prowlarr.pez.sh |
| Transmission | 9091 | download.pez.sh |
| Jellyseerr | 5055 | request.pez.sh |

### Other

| Service | Port | URL |
|---------|------|-----|
| Nextcloud AIO | 11000 | cloud.pez.sh |
| slskd (Soulseek) | 5030 | soulseek.pez.sh |
| smartctl_exporter | 9633 | (Prometheus scrape) |
| prom-plex-exporter | — | (Prometheus scrape) |

All services run in Docker. Media is served directly from the ZFS pool.

## Networking

Connected via Cat 5 to the Ubiquiti switch in the utility closet. 1 Gbit LAN connection.
