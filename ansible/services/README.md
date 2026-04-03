# Services

Version-controlled service definitions across the fleet.

## Directory Structure

```
services/
├── systemd/              # systemd unit files (Linux hosts)
│   ├── copenhagen-a/
│   │   ├── mangos-realmd.service   # MaNGOS Zero realm server
│   │   └── mangos-world.service    # MaNGOS Zero world server
│   └── helsinki-a/
│       ├── caddy.service                    # Caddy reverse proxy (stock unit)
│       └── thiswebsitedoesnotexist.service  # Node.js app on port 3721
└── rc.d/                 # FreeBSD rc.conf and rc.d scripts
    └── london-a/
        └── rc.conf       # /etc/rc.conf — all enabled services
```

## Notes

### copenhagen-a (Linux)

| Service | Unit | Status | Notes |
|---------|------|--------|-------|
| MaNGOS realmd | `mangos-realmd.service` | enabled, custom | Realm server for WoW private server. Depends on MariaDB. |
| MaNGOS world | `mangos-world.service` | enabled, custom | World server. Depends on MariaDB and realmd. |

### helsinki-a (Linux)

| Service | Unit | Status | Notes |
|---------|------|--------|-------|
| Caddy | `caddy.service` | enabled, stock | Installed via package manager. Config at `/etc/caddy/Caddyfile`. |
| thiswebsitedoesnotexist | `thiswebsitedoesnotexist.service` | enabled, custom | Node.js app. Env vars in `/opt/thiswebsitedoesnotexist/.env`. |

### london-a (FreeBSD)

No custom rc.d scripts — all services installed via `pkg`. The `rc.conf` captures all enabled services:

| Service | rc.conf variable | Notes |
|---------|-----------------|-------|
| Grafana | `grafana_enable="YES"` | Monitoring dashboards |
| Prometheus | `prometheus_enable="YES"` | Metrics collection |
| node_exporter | `node_exporter_enable="YES"` | Host metrics exporter |
| Tailscale | `tailscaled_enable="YES"` | Mesh VPN |
| InfluxDB | `influxd_enable="YES"` | Time-series database |
| libvirtd | `libvirtd_enable="YES"` | Virtualisation daemon |
| Redis | `redis_enable="YES"` | In-memory data store |
| PostgreSQL | `postgresql_enable="YES"` | Relational database |


