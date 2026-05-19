# copenhagen-c

Raspberry Pi at the Copenhagen site. General-purpose / off-site utility box.

## Overview

| | |
|---|---|
| **Location** | Copenhagen |
| **OS** | Debian 12 (Bookworm), aarch64 |
| **Tailscale IP** | 100.115.45.53 |
| **Role** | Idle / cloudflared tunnel |
| **Form factor** | Raspberry Pi (ARM64) |

## Services

| Service | Deployment | Notes |
|---------|-----------|-------|
| cloudflared | Native (systemd) | Cloudflare-managed tunnel for ad-hoc exposure of services from this site |
| Tailscale | Native | Mesh networking |
| Alloy | Native | Ships metrics/logs to Grafana Cloud |
| node_exporter | Native | Host metrics |
| Docker / containerd | Native | Available, but no compose services currently scheduled here |

The cloudflared token is stored directly in the systemd unit (`/etc/systemd/system/cloudflared.service`); the tunnel itself is configured in the Cloudflare dashboard.

## Notes

Part of the Copenhagen off-site setup at my dad's place. Otherwise idle — available if I need to spin up something that benefits from a Copenhagen location or just need another always-on box.
