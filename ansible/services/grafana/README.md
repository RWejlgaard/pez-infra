# Grafana

Grafana dashboards, alerting rules, and provisioning config for the homelab/cloud stack.
Runs on **london-a** (FreeBSD, `100.122.219.41`) as a native service (not Docker).

Migrated from the standalone `pez-grafana` repo.

## Structure

```
services/grafana/
├── dashboards/                        # Dashboard JSON files
│   ├── infrastructure.json            # Infrastructure overview (linux hosts)
│   ├── living-room-display.json       # Kiosk/TV dashboard
│   ├── node-exporter-full.json        # Full node exporter metrics
│   └── traffic-slo.json              # Traffic / SLO tracking
└── provisioning/                      # Grafana provisioning files
    ├── alerting/
    │   ├── contact-points.yml         # Alert receivers (PagerDuty, email)
    │   ├── notification-policy.yml    # Routing: critical → PagerDuty, warning → email
    │   ├── rules-critical.yml         # Tier 1: pages PagerDuty immediately
    │   └── rules-warning.yml          # Tier 2: email only
    ├── dashboards/
    │   └── dashboards.yml             # Dashboard file provider config
    └── datasources/
        └── datasources.json           # Prometheus datasource (localhost:9090)
```

## Alert Tiers

| Tier     | Routing    | Examples                                   |
|----------|------------|--------------------------------------------|
| Critical | PagerDuty  | Host down, disk >95%, memory >95%          |
| Warning  | Email      | Disk >80%, memory >85%, high load/CPU      |

## Deployment

Deployed via the monorepo's `ansible/deploy.yml` (Stage 4e: Monitoring stack).

```bash
cd ansible
ansible-playbook deploy.yml --limit london-a --tags monitoring
```

Provisioning files are synced to `/usr/local/etc/grafana/provisioning/` and dashboards
to `/usr/local/etc/grafana/dashboards/` on london-a. Grafana is restarted after changes.

### Notes

- The old `pez-grafana` repo deployed provisioning to `/usr/local/share/grafana/conf/provisioning/`.
  The monorepo uses `/usr/local/etc/grafana/` — verify the correct path on london-a before first deploy.
- PagerDuty integration key is referenced via `${PAGERDUTY_INTEGRATION_KEY}` env var (not stored in repo).
- Grafana password is not committed; pass via `--extra-vars` or env.

## Importing Dashboards Manually

```bash
curl -X POST -H "Content-Type: application/json" \
  -u admin:password \
  -d "{\"dashboard\": $(cat dashboards/infrastructure.json), \"overwrite\": true}" \
  http://localhost:3000/api/dashboards/db
```
