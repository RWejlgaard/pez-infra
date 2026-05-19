# helsinki-a

Public-facing traffic gateway. Everything exposed to the internet goes through this box.

## Overview

| | |
|---|---|
| **Location** | Hetzner Cloud (Helsinki) |
| **OS** | Debian 13 (Trixie) |
| **Tailscale IP** | 100.67.6.27 |
| **Role** | Reverse proxy, SSO, Bitwarden, Forgejo |
| **Provider** | Hetzner Cloud VPS |

## What it does

This is the front door. All public subdomains under `pez.sh` and `pez.solutions` terminate here via Caddy, which proxies traffic to the appropriate backend over Tailscale.

It also runs the auth stack — Authelia for SSO and LLDAP as Authelia's user backend. Having auth on the same box as the proxy keeps latency low for the `forward_auth` check.

Bitwarden (Vaultwarden) and Forgejo also live here. Both expose their own login and don't go through Authelia. Bitwarden is on helsinki-a for availability — password management needs to be reachable even if the London servers are having a moment. Forgejo is colocated for the same reason and to keep Git access independent of home internet.

## Services

| Service | Port | Deployment | Notes |
|---------|------|-----------|-------|
| Caddy | 80, 443 | Native (apt + systemd) | Reverse proxy + TLS termination. Config at `/etc/caddy/Caddyfile` |
| Authelia | 9091 | Docker | SSO, accessible at auth.pez.sh |
| Authelia MariaDB | (internal) | Docker | Authelia session/state |
| LLDAP | 3890, 17170 | Docker | User directory for Authelia (UI at ldap.pez.sh) |
| Bitwarden (Vaultwarden) | 8443, 8080 | Docker | bitwarden.pez.sh, own auth |
| Bitwarden MariaDB | (internal) | Docker | Backing DB |
| Forgejo | 3000 (HTTP), 2222 (SSH) | Docker | git.pez.sh, own auth; SSH on `git.pez.sh:2222` |

Caddy is the only service installed natively — it needs to bind 80/443 directly and there's no benefit to wrapping it in Docker on a single-purpose proxy host. Everything else runs as Docker Compose stacks under `/opt/docker/<service>/` (managed by the `docker_services` Ansible role from `ansible/services/<service>/docker-compose.yml`).

### Static sites

Caddy also serves static content from `/srv/`:

| Path | URL | Auth |
|---|---|---|
| `/srv/status` | status.pez.sh | — |
| `/srv/apps` | apps.pez.sh, apps.pez.solutions | Authelia |
| `/srv/pez.sh` | pez.sh | — |
| `/srv/pez.solutions` | pez.solutions | — |
| `/srv/pez-signup` | signup.pez.solutions | — |

## Why Hetzner Cloud

Public-facing services need a stable public IP and good uptime. Residential IPs are dynamic and unreliable for this purpose. Hetzner Cloud is cheap, reliable, and has good European connectivity.
