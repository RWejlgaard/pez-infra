# Authelia

SSO authentication portal with LLDAP directory and MariaDB backend.

- **Host:** helsinki-a (100.67.6.27)
- **URL:** https://auth.pez.sh / https://auth.pez.solutions
- **Components:**
  - **Authelia** — SSO portal (port 9091, localhost only)
  - **LLDAP** — Lightweight LDAP directory (port 3890 LDAP, port 17170 web UI)
  - **MariaDB 11** — Session/config storage
- **Config:** `/root/authelia/config/configuration.yml`
- **Secrets:** `/root/authelia/secrets/` (mounted into containers)
- **LDAP base DN:** `dc=pez,dc=sh`

## Secrets

All secrets are stored in `config.enc.yml` (SOPS-encrypted with age).

To decrypt: `sops -d config.enc.yml`

Secret files expected in `/root/authelia/secrets/` on helsinki-a:

| File | Source key in config.enc.yml | Used by |
|------|------------------------------|---------|
| `JWT_SECRET` | `jwt_secret` | Authelia (password reset JWT) |
| `SESSION_SECRET` | `session_secret` | Authelia (session encryption) |
| `STORAGE_ENCRYPTION_KEY` | `storage_encryption_key` | Authelia (DB encryption) |
| `MYSQL_PASSWORD` | `mysql_password` | Authelia + MariaDB |
| `MYSQL_ROOT_PASSWORD` | `mysql_root_password` | MariaDB |
| `LLDAP_ADMIN_PASSWORD` | `lldap_admin_password` | LLDAP + Authelia (LDAP bind) |
| `LLDAP_JWT_SECRET` | `lldap_jwt_secret` | LLDAP |
| `SMTP_PASSWORD` | `smtp_password` | Authelia (email notifications) |

## Access Control

Default policy: **deny**. Per-service access via LLDAP groups (e.g. `pez_grafana_users`).
Domains covered: `*.pez.sh` and `*.pez.solutions` (mirrors).

## Deployment

1. Decrypt secrets: `sops -d config.enc.yml > /tmp/secrets.yml`
2. Write each key as a file to `/root/authelia/secrets/<FILENAME>`
3. Copy `configuration.yml` to `/root/authelia/config/`
4. Copy `docker-compose.yml` to `/root/authelia/`
5. `docker compose up -d`

> **Note:** The current deployment lives at `/root/authelia/` (not `/opt/docker/authelia/`).
> The Ansible `docker_services` role deploys to `/opt/docker/` — if adding authelia
> to `docker_services` in host_vars, the paths in docker-compose.yml or the deploy
> target would need to be reconciled.
