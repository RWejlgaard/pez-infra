# london-a

Dedicated monitoring server. Runs Prometheus and Grafana, nothing else.

## Overview

| | |
|---|---|
| **Location** | London (NW9) |
| **OS** | FreeBSD 14.3 |
| **Tailscale IP** | 100.122.219.41 |
| **Role** | Monitoring (Prometheus + Grafana) |

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel i7-4790K (8 threads) |
| Memory | 32 GB |
| Boot disk | 1 TB |

Old gaming PC, now perfectly happy as a monitoring host. Very lightly loaded — disk at ~6%.

## Services

| Service | Port | Status | Notes |
|---------|------|--------|-------|
| Prometheus | 9090 | Active | prometheus.pez.sh |
| Grafana | 3000 | Active | grafana.pez.sh |
| node_exporter | 9100 | Active | Metrics exporter |
| cloudflared | — | Active | Tunnel 168eccae-... proxying Grafana/Prometheus |
| Tailscale | — | Active | Mesh networking |

Both Prometheus and Grafana are behind Authelia (auth handled by Caddy on helsinki-a).

### Unused services (audit 2026-03-30)

These services are enabled in rc.conf but appear unused. Pending cleanup.

| Service | Port | Finding |
|---------|------|---------|
| InfluxDB | 8086 (all interfaces!) | Only `_internal` database — never used. Listening on `*:8086` is also a security concern. |
| Redis | 6379 (localhost) | Empty keyspace, no clients. |
| PostgreSQL | 5432 (localhost) | Has `pez_vps` database from a defunct VPS management project. Data may need backup before removal. |
| libvirtd | — | Zero VMs. Installed for the same pez_vps project. |

## ZFS

- Pool: `zroot`
- Weekly scrub: `0 12 * * sun zpool scrub zroot` (root crontab, not ansible-managed yet)

## Why FreeBSD

This one runs FreeBSD instead of Ubuntu. For a single-purpose monitoring host it works well. No particular reason to change it — it's stable and does its job.

## Networking

Connected via Cat 5 to the Ubiquiti switch alongside london-b.

## Notes

Prometheus scrapes all hosts over Tailscale. See [monitoring.md](../monitoring.md) for scrape targets and dashboard details.
