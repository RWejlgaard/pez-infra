# Ansible — Deploy & Maintain

One-command deploy playbook for rebuilding hosts from repo state.

## Quick Start

```bash
cd ansible/

# Install dependencies
make deps

# Dry run — see what would change
make deploy-check

# Deploy everything
make deploy

# Deploy a single host
make deploy-host HOST=helsinki-a
```

## Playbooks

| Playbook | Purpose | Usage |
|----------|---------|-------|
| `deploy.yml` | Full host rebuild from repo | `make deploy` or `--limit <host>` |
| `playbooks/update-all.yml` | OS package updates (all hosts) | `make update-all` |
| `playbooks/update-linux.yml` | Linux-only updates (apt + apk) | `make update-linux` |
| `playbooks/update-freebsd.yml` | FreeBSD-only updates (pkg) | `make update-freebsd` |
| `playbooks/docker-status.yml` | Show running containers | `make docker-status` |
| `playbooks/reboot.yml` | Safe reboot with pre-flight | `make reboot HOST=<host>` |

## Deploy Stages

The deploy playbook runs in stages, each independently taggable:

1. **common** — Baseline packages, SSH hardening, fish shell
2. **docker** — Docker engine on container hosts
3. **node-exporter** — Prometheus monitoring agent on all hosts
4. **services** — Per-host service deployment:
   - `helsinki-a`: Caddy reverse proxy
   - `london-b`: Docker Compose services (Nextcloud, Jellyseer, etc.)
   - `nuremberg-a`: poste.io mail
   - `copenhagen-a`: Minecraft + MaNGOS systemd services
   - `london-a`: Prometheus + Grafana (FreeBSD)
5. **verify** — Post-deploy health check

Run a single stage: `ansible-playbook deploy.yml --tags docker`

## Roles

| Role | Description |
|------|-------------|
| `common` | Base packages, SSH hardening, fish shell |
| `docker` | Docker engine install and setup |
| `docker-services` | Deploy compose files from `services/` |
| `dotfiles` | Shell config from `dotfiles/` |
| `caddy` | Caddy reverse proxy (helsinki-a) |
| `node-exporter` | Prometheus node_exporter |
| `systemd-services` | Custom systemd units from `services/` |

## Inventory

Hosts are grouped by OS and role. All use Tailscale IPs, SSH as root.
Per-host variables in `inventory/host_vars/<hostname>.yml`.

## Safety Notes

- **london-b**: Reboot playbook requires interactive confirmation (critical storage)
- **copenhagen-a**: Reboot includes netplan pre-flight check (static IP verification)
- All playbooks use `ignore_unreachable: true` for fleet operations
- `--check --diff` is your friend — always dry-run first on production
