# london-c

Raspberry Pi at the London site. Edge utility box for lightweight workloads that don't justify spinning up the Threadripper.

## Overview

| | |
|---|---|
| **Location** | London (NW9) |
| **OS** | Debian 13 (Trixie), aarch64 |
| **Tailscale IP** | 100.123.72.87 |
| **Role** | Octopus Energy exporter, general-purpose Pi |
| **Form factor** | Raspberry Pi (ARM64) |

## Services

| Service | Port | Deployment | Notes |
|---------|------|-----------|-------|
| octopus_exporter | 9359 | Docker (`rwejlgaard/octopus_exporter`) | Pulls electricity-usage data from the Octopus Energy API; scraped by Alloy |
| Tailscale | — | Native | Mesh networking |
| Docker / containerd | — | Native | For octopus-exporter |
| Alloy | — | Native (Ansible-managed) | Ships metrics/logs to Grafana Cloud |
| node_exporter | 9100 | Native | Host metrics |
| systemd_exporter | — | Native | systemd unit metrics |
| fail2ban | — | Native | SSH brute-force protection |

Compose file lives at `ansible/services/octopus-exporter/docker-compose.yml`. The `OCTOPUS_API_KEY` is templated in from a SOPS-encrypted variable.

## Networking

Connected via Ethernet to the Ubiquiti switch alongside london-a and london-b.

## Notes

- Single-board-computer form factor — runs cool, draws ~5 W, lives on the rack shelf without active cooling.
- A natural place to park future "small but always-on" workloads (sensors, cron jobs, smart-home glue) that don't need to share fate with london-b.
