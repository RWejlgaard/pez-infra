# Getting Started

How to work with this repo, deploy changes, and not break things.

## Prerequisites

You'll need:

- **Tailscale** — installed and connected to the tailnet. All SSH access goes through Tailscale. No servers have SSH exposed on the public internet.
- **SSH keys** — set up for each host you need to access
- **Ansible** — for configuration management and deployments (`make deps` from `ansible/` installs collections)
- **OpenTofu** (or Terraform) — for Hetzner (servers + DNS), Grafana Cloud, and PagerDuty
- **Docker** — helpful to understand, since most services are containerised
- **SOPS + age** — for secrets encryption/decryption (see [Secrets](secrets.md) for setup)
- **Git** — obviously
- **gh CLI** — for GitHub operations (PRs, issues, etc.)

## Clone the repo

```bash
git clone git@github.com:RWejlgaard/pez-infra.git
cd pez-infra
```

## Repo Structure

```
pez-infra/
├── docs/           # You are here
├── ansible/        # Ansible playbooks, roles, inventory, and all managed files
│   ├── roles/      # Ansible roles (common, caddy, docker, media_stack, proxmox_ve, etc.)
│   ├── services/   # Docker Compose definitions and service configs
│   ├── dotfiles/   # Shell config (fish, nvim, tmux, git, etc.)
│   ├── playbooks/  # One-off playbooks (updates, reboots, status)
│   └── scripts/    # Utility and maintenance scripts
└── terraform/      # Terraform/OpenTofu for Hetzner (servers + DNS), Grafana Cloud, PagerDuty
```

## Connecting to hosts

All access is via Tailscale, as `root`. Once you're on the tailnet, SSH using the Tailscale IP or hostname:

```bash
ssh root@helsinki-a        # or ssh root@100.67.6.27
ssh root@london-a          # Proxmox VE host
ssh root@london-b          # storage / media
ssh root@london-c          # Raspberry Pi
ssh root@copenhagen-a      # Proxmox VE host
ssh root@nuremberg-a
```

## Common Tasks

### Deploying configuration changes

Ansible handles deployments. The unified `deploy.yml` rebuilds a host from bare-metal-with-Tailscale to fully configured.

```bash
cd ansible/

# Install collections
make deps

# Dry run — see what would change
make deploy-check

# Deploy everything
make deploy

# Deploy a single host
make deploy-host HOST=london-b

# Or run a single stage
ansible-playbook deploy.yml --tags docker
```

Ansible also runs automatically via GitHub Actions on commits to the main branch — so a quick commit from your phone can fix a misconfiguration when you're out.

Other playbooks live under `ansible/playbooks/`:

| Playbook | Purpose |
|---|---|
| `update-all.yml` | OS package updates (all hosts) |
| `update-linux.yml` | Linux-only updates (apt) |
| `docker-status.yml` | Show running containers per host |
| `reboot.yml` | Safe reboot with pre-flight (interactive confirm for london-b) |
| `zfs.yml` | ZFS scrub scheduling |

### Managing cloud + DNS + observability

Terraform manages Hetzner servers + DNS, Grafana Cloud (stack, fleet, dashboards, synthetic checks), and PagerDuty:

```bash
cd terraform
make init   # initialize providers and B2 backend
make plan   # preview changes
make apply  # apply the changes
```

State lives in a Backblaze B2 bucket (`pez-infra-tfstate`) via the S3-compatible backend. Don't click around in the Hetzner or Grafana Cloud dashboards — if it's not in Terraform, it doesn't exist.

### Adding a new service

1. **Create a Docker Compose file** in `ansible/services/<service-name>/docker-compose.yml` (or a systemd unit if it's native)
2. **Add the host_var** — list the service under `docker_services` (or `systemd_services`) in `ansible/inventory/host_vars/<host>.yml`
3. **Add the Caddy route** — if it needs a public subdomain, add a block to `ansible/services/caddy/Caddyfile`
4. **Add a DNS record** — add the subdomain to `terraform/hetzner/dns.tf` and run `tofu apply`
5. **Add monitoring** — if the service has a metrics endpoint, scrape it via Alloy (`terraform/grafana/fleet_pipelines/`)
6. **Update docs** — add the service to `docs/services.md` (and the relevant `docs/hosts/<host>.md` page)

### Adding a new server

1. Install the OS (Debian 13 or Ubuntu LTS preferred — see below)
2. Set up SSH keys for `root`
3. Install Tailscale and join the tailnet
4. Add the host to `ansible/inventory/hosts.ini` and create `ansible/inventory/host_vars/<host>.yml`
5. Run `make deploy-host HOST=<new-host>` from `ansible/`
6. Register the host as a Grafana Fleet collector in `terraform/grafana/fleet_collectors.tf` and `tofu apply`
7. Add a doc at `docs/hosts/<host>.md` and update `docs/services.md` + `docs/architecture.md`

That's it. The common role installs node_exporter, systemd_exporter, and Alloy as part of the baseline, so observability is automatic.

### Working with ZFS (london-b)

```bash
# Check pool status
zpool status hdd

# Check usage
zfs list

# Scrub status (runs weekly on Sundays at 12:00)
zpool status hdd | grep scan
```

ZFS is set up with 3× RAIDZ1 vdevs of 4 drives each (12 drives total) on the `hdd` pool. Tolerates one drive failure per vdev. The long-term plan is to replace the 8 TB drives with 24 TB drives and grow the pool toward 24 drives / ~0.5 PB raw.

## OS Choice

- **Debian (12 or 13)** is the default for new hosts — including the Raspberry Pis. Stable, well-supported by Ansible, predictable.
- **Ubuntu LTS** is on london-b (historical — came up before the Debian standard).
- **Proxmox VE** (Debian Bookworm under the hood) on london-a and copenhagen-a.
- **No more FreeBSD.** london-a used to run FreeBSD for Prometheus/Grafana; that's all on Grafana Cloud now and london-a is Linux/Proxmox.

Alpine has been tried and rejected — the missing GNU binaries / systemd caused enough Ansible headaches to not be worth the size savings.

## Secrets

Secrets are encrypted in-repo using **SOPS + age**. Encrypted files have `.enc.` in their extension (e.g. `secrets.enc.yaml`).

```bash
# Edit an encrypted file
sops ansible/services/authelia/config.enc.yml

# Decrypt to stdout
sops -d ansible/services/authelia/config.enc.yml
```

Full documentation: [docs/secrets.md](secrets.md)

## Branching

- `main` is the production branch. Ansible runs from main via GitHub Actions.
- Feature branches for changes, PRs for review.
- Branch naming: `<author>/PESO-<number>-<description>` for Jira-tracked work.

## Consolidated Repos

This monorepo replaces several standalone repos:

| Old repo | Now lives in |
|----------|-------------|
| pez-ansible | `ansible/` |
| pez-terraform | `terraform/` |
| pez-grafana | `terraform/grafana/` |
| pez-proxy | `ansible/services/caddy/` |
| pez-docs | `docs/` |
| server-scripts | `ansible/scripts/` and `ansible/roles/` |
