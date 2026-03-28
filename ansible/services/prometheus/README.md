# Prometheus

Runs on **london-a** (FreeBSD, 100.122.219.41).

## Service Details

- **Binary:** `/usr/local/bin/prometheus`
- **Config:** `/usr/local/etc/prometheus.yml`
- **Data:** `/var/db/prometheus`
- **Web UI:** `http://london-a:9090`
- **Runs as:** `prometheus` user via daemon(8)

## Scrape Targets

| Job | Target | Host | Port | What it scrapes |
|-----|--------|------|------|-----------------|
| `prometheus` | localhost:9090 | london-a | 9090 | Prometheus self-metrics |
| `node_exporter` | 192.168.1.254:9100 | london-a | 9100 | OS metrics (FreeBSD) |
| `node_exporter` | 192.168.1.253:9100 | london-b | 9100 | OS metrics (Linux) |
| `node_exporter` | 100.89.206.60:9100 | copenhagen-a | 9100 | OS metrics (Linux) |
| `node_exporter` | 100.115.45.53:9100 | copenhagen-c | 9100 | OS metrics (Linux) |
| `node_exporter` | 100.117.235.28:9100 | nuremberg-a | 9100 | OS metrics (Alpine) |
| `node_exporter` | 100.67.6.27:9100 | helsinki-a | 9100 | OS metrics (Linux) |
| `smartmontools` | 192.168.1.253:9633 | london-b | 9633 | SMART disk health (smartctl_exporter) |
| `plex` | 192.168.1.253:9000 | london-b | 9000 | Plex media server metrics |
| `caddy` | 100.67.6.27:2019 | helsinki-a | 2019 | Caddy admin API / metrics |

### Network Notes

- London hosts (london-a, london-b) use **LAN IPs** (192.168.1.x) since Prometheus runs locally in the London rack
- Remote hosts (copenhagen, nuremberg, helsinki) use **Tailscale IPs** (100.x.x.x)

## Alerting Rules

### `rules/node-exporter.rules`

Sourced from pez-ansible. Currently all rules are **commented out** — only a placeholder `ServerRunningBtrfs` alert exists (disabled). No active alerting rules or Alertmanager configured.

## What's Not Configured

- **Alertmanager** — target is commented out; no alerting pipeline active
- **Rule files** — referenced lines in `prometheus.yml` are commented out (rules exist in `rules/` but aren't loaded)
- **Recording rules** — none

## Deployment

Config is managed manually on london-a. To deploy changes:

```bash
# Copy config to london-a
scp prometheus.yml root@100.122.219.41:/usr/local/etc/prometheus.yml

# Reload (graceful, no restart needed)
ssh root@100.122.219.41 "kill -HUP $(pgrep prometheus)"
```
