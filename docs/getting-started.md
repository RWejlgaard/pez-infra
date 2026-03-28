# Getting Started

How to work with this repo, deploy changes, and not break things.

## Prerequisites

You'll need:

- **Tailscale** — installed and connected to the tailnet. All SSH access goes through Tailscale. No servers have SSH exposed on the public internet.
- **SSH keys** — set up for each host you need to access
- **Ansible** — for configuration management and deployments
- **OpenTofu** (or Terraform) — for managing Cloudflare DNS and infrastructure
- **Docker** — helpful to understand, since most services are containerised
- **SOPS + age** — for secrets encryption/decryption (run `./scripts/sops-setup.sh`)
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
│   ├── roles/      # Ansible roles (caddy, docker, dotfiles, etc.)
│   ├── services/   # Docker Compose definitions and service configs
│   ├── dotfiles/   # Shell config (fish, nvim, tmux, git, etc.)
│   └── scripts/    # Utility and maintenance scripts
└── terraform/      # Terraform/OpenTofu for Cloudflare, DNS, etc.
```

## Connecting to hosts

All access is via Tailscale. Once you're on the tailnet, SSH using the Tailscale IP or hostname:

```bash
ssh root@helsinki-a        # or ssh root@100.67.6.27
ssh root@london-b         # or ssh root@100.84.65.101
ssh root@london-a         # FreeBSD — might need a different user
ssh root@copenhagen-a     # or ssh root@100.89.206.60
```

## Common Tasks

### Deploying configuration changes

Ansible handles deployments. Playbooks are in `ansible/` and are structured by host/role.

```bash
# Run the full site playbook
cd ansible
ansible-playbook site.yml

# Target a specific host
ansible-playbook site.yml --limit london-b

# Dry run first
ansible-playbook site.yml --check --diff
```

Ansible also runs automatically via GitHub Actions on commits to the main branch — so a quick commit from your phone can fix a misconfiguration when you're out.

### Managing DNS

DNS records are managed via Terraform in the `terraform/` directory:

```bash
cd terraform
tofu plan          # see what would change
tofu apply         # apply the changes
```

All Cloudflare DNS records, pages, and access policies are defined here. Don't click around in the Cloudflare dashboard — if it's not in Terraform, it doesn't exist.

### Adding a new service

1. **Create a Docker Compose file** in `ansible/services/<service-name>/docker-compose.yml`
2. **Add the Caddy route** — if it needs a public subdomain, add a block to the Caddyfile in `ansible/services/caddy/`
3. **Add a DNS record** — add the subdomain to `terraform/` and run `tofu apply`
4. **Add Ansible deployment** — create or update the relevant role in `ansible/` so the service gets deployed automatically
5. **Add monitoring** — if the service has a metrics endpoint, add it as a Prometheus scrape target
6. **Update docs** — add the service to `docs/services.md`

### Adding a new server

1. Install the OS (Ubuntu preferred — see below)
2. Set up SSH keys
3. Install Tailscale and join the tailnet
4. Add the host to the Ansible inventory in `ansible/`
5. Assign roles (at minimum: node_exporter for monitoring)
6. Run `ansible-playbook site.yml --limit <new-host>`
7. Update `docs/services.md` and `docs/architecture.md`

That's it. Ansible takes care of installing node_exporter, configuring the system, and deploying any assigned services.

### Working with ZFS (london-b)

```bash
# Check pool status
zpool status hdd

# Check usage
zfs list

# Scrub status (runs weekly on Sundays)
zpool status hdd | grep scan
```

ZFS is set up with 3× RAIDZ1 vdevs across 8 drives. Tolerates one drive failure per vdev.

## OS Choice

Ubuntu is the preferred OS for new servers. Not because I love it — Alpine is faster and leaner — but because Ansible support is vastly better. The lack of GNU binaries and systemd on Alpine caused enough headaches that the switch to Ubuntu was worth it.

FreeBSD is used on london-a (monitoring) and works well for that single-purpose role.

## Secrets

Secrets are encrypted in-repo using **SOPS + age**. Encrypted files have `.enc.` in their extension (e.g. `secrets.enc.yml`).

```bash
# First-time setup
./ansible/scripts/sops-setup.sh

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
| pez-grafana | `services/grafana/` |
| pez-proxy | `services/caddy/` |
| pez-docs | `docs/` |
| server-scripts | `scripts/` and `ansible/` |
