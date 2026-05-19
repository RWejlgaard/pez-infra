# Documentation

Everything you need to understand how this infrastructure works.

## Contents

- **[Architecture](architecture.md)** — High-level overview, network topology, traffic flow diagrams
- **[Networking](networking.md)** — Tailscale mesh, physical networking, DNS and proxy flow
- **[Services](services.md)** — Complete service map: what runs where, ports, auth
- **[Monitoring](monitoring.md)** — Grafana Cloud, Alloy, synthetic checks, alerting via PagerDuty
- **[Secrets](secrets.md)** — SOPS + age encryption: setup, usage, CI integration
- **[Getting Started](getting-started.md)** — How to work with this repo, deploy changes, add services
- **[Hosts](hosts/)** — Per-host detail (hardware, services, quirks)

## Quick Reference

| Host | Tailscale IP | Location | Role |
|------|-------------|----------|------|
| helsinki-a | 100.67.6.27 | Hetzner Cloud (Helsinki) | Reverse proxy, SSO, Bitwarden, Forgejo |
| london-a | 100.122.180.98 | London | Proxmox VE hypervisor |
| london-b | 100.84.65.101 | London | Storage, media, Docker services |
| london-c | 100.123.72.87 | London | Raspberry Pi, Octopus Energy exporter |
| nuremberg-a | 100.70.180.24 | Hetzner Cloud (Nuremberg) | Mail (poste.io) |
| copenhagen-a | 100.89.206.60 | Copenhagen | Minecraft, WoW/MaNGOS |
| copenhagen-c | 100.115.45.53 | Copenhagen | Raspberry Pi, cloudflared, idle |
