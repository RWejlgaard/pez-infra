# helsinki-a

Public-facing traffic gateway. Everything exposed to the internet goes through this box.

## Overview

| | |
|---|---|
| **Location** | Hetzner Cloud (Helsinki) |
| **OS** | Linux (Ubuntu/Debian) |
| **Tailscale IP** | 100.67.6.27 |
| **Role** | Reverse proxy, SSO, Bitwarden, LDAP |
| **Provider** | Hetzner Cloud VPS |

## What it does

This is the front door. All public subdomains (*.pez.sh) terminate here via Caddy, which proxies traffic to the appropriate backend over Tailscale.

It also runs the auth stack — Authelia for SSO and LLDAP for user management. Having auth on the same box as the proxy keeps latency low for the `forward_auth` check.

Bitwarden (Vaultwarden) lives here too, because password management needs to be available even if the London servers are having a moment.

## Services

| Service | Port | Deployment | Notes |
|---------|------|-----------|-------|
| Caddy | 80, 443 | Docker | Reverse proxy + TLS termination |
| Authelia | 9091 | Docker | SSO, accessible at auth.pez.sh |
| Bitwarden (Vaultwarden) | 8443 | Docker | bitwarden.pez.sh, own auth |
| LLDAP | 3890/17170 | Docker | User directory for Authelia |

Also serves static content:
- **status.pez.sh** → `/srv/status` (public status page)
- **apps.pez.sh** → `/srv/apps` (behind Authelia)

## Why Hetzner Cloud

Public-facing services need a stable public IP and good uptime. Residential IPs are dynamic and unreliable for this purpose. Hetzner Cloud is cheap, reliable, and has good European connectivity.
