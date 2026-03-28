# Documentation

Everything you need to understand how this infrastructure works.

## Contents

- **[Architecture](architecture.md)** — High-level overview, network topology, traffic flow diagrams
- **[Networking](networking.md)** — Tailscale mesh, physical networking, DNS and proxy flow
- **[Services](services.md)** — Complete service map: what runs where, ports, auth
- **[Monitoring](monitoring.md)** — Prometheus, Grafana, exporters, alerting, status page
- **[Secrets](secrets.md)** — SOPS + age encryption: setup, usage, CI integration
- **[Getting Started](getting-started.md)** — How to work with this repo, deploy changes, add services

## Quick Reference

| Host | Tailscale IP | Location | Role |
|------|-------------|----------|------|
| helsinki-a | 100.67.6.27 | Hetzner Cloud | Reverse proxy, SSO, Bitwarden |
| london-b | 100.84.65.101 | London | Storage, media, Docker services |
| london-a | 100.122.219.41 | London | Prometheus + Grafana |
| nuremberg-a | 100.117.235.28 | Hetzner Cloud | Mail (poste.io) |
| copenhagen-a | 100.89.206.60 | Copenhagen | Minecraft, WoW |
| copenhagen-c | 100.115.45.53 | Copenhagen | Idle |
