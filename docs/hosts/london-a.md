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

| Service | Port | URL |
|---------|------|-----|
| Prometheus | 9090 | prometheus.pez.sh |
| Grafana | 3000 | grafana.pez.sh |

Both are behind Authelia (auth handled by Caddy on helsinki-a).

## Why FreeBSD

This one runs FreeBSD instead of Ubuntu. For a single-purpose monitoring host it works well. No particular reason to change it — it's stable and does its job.

## Networking

Connected via Cat 5 to the Ubiquiti switch alongside london-b.

## Notes

Prometheus scrapes all hosts over Tailscale. See [monitoring.md](../monitoring.md) for scrape targets and dashboard details.
