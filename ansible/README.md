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
| `playbooks/update-all.yml` | OS package updates (all hosts, apt) | `make update-all` |
| `playbooks/update-linux.yml` | Alias for update-all (apt) | `make update-linux` |
| `playbooks/docker-status.yml` | Show running containers | `make docker-status` |
| `playbooks/reboot.yml` | Safe reboot with pre-flight | `make reboot HOST=<host>` |
| `playbooks/zfs.yml` | ZFS scrub scheduling (london-b) | `ansible-playbook playbooks/zfs.yml` |

## Deploy Stages

The deploy playbook runs in stages, each independently taggable (see `deploy.yml`):

1. **common / baseline** — Baseline packages, SSH hardening, fish shell, dotfiles
2. **docker** — Docker engine on container hosts (`docker_hosts` group)
3. **services** — Per-host service deployment:
   - `helsinki-a`: Caddy + status-page + custom systemd units
   - `docker_hosts`: Docker Compose stacks from `services/`
   - `nuremberg-a`: poste.io mail (Docker)
   - `london-b`: `media_stack` + `backup` (rclone to B2)
   - `proxmox_hosts` (`london-a`, `copenhagen-a`): `proxmox_ve` (apt repo, nag patch, CIFS storage)
   - `zfs_hosts`: ZFS scrub scheduling

Observability (node_exporter, systemd_exporter, Grafana Alloy) is part of the `common` baseline — every host gets it.

Run a single stage: `ansible-playbook deploy.yml --tags docker`

## Roles

| Role | Description |
|------|-------------|
| `common` | Base packages, SSH hardening, fish shell, exporters, Alloy |
| `dotfiles` | Shell config from `dotfiles/` |
| `docker` | Docker engine install and setup + monthly log-cleanup cron |
| `docker_services` | Deploy compose files from `services/` |
| `caddy` | Caddy reverse proxy (helsinki-a) |
| `status_page` | status.pez.sh generator script + cron |
| `systemd_services` | Custom systemd units from `services/` |
| `media_stack` | *Arr stack, Plex/Jellyfin, Samba, Syncthing on london-b |
| `backup` | rclone-to-B2 cron job on london-b |
| `proxmox_ve` | PVE no-subscription repo, UI lockdown, CIFS storage |
| `zfs` | Weekly scrub cron on ZFS hosts |

## Inventory

Hosts are grouped by OS and role. All use Tailscale IPs, SSH as root.
Per-host variables in `inventory/host_vars/<hostname>.yml`.

## Safety Notes

- **london-b**: Reboot playbook requires interactive confirmation (critical storage)
- All playbooks use `ignore_unreachable: true` for fleet operations
- `--check --diff` is your friend — always dry-run first on production
