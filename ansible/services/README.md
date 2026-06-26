# Services

Version-controlled service definitions across the fleet. Each subdirectory is a single deployable unit — either a Docker Compose stack, a systemd unit, or a static config file set — that the Ansible roles in `ansible/roles/` pick up and deploy.

## Layout

```
services/
├── <service-name>/
│   ├── docker-compose.yml      # Docker services
│   ├── <service>.service       # Native systemd unit (when applicable)
│   ├── config/                 # Mounted/copied config files
│   ├── *.enc.{yml,yaml,env}    # SOPS-encrypted secrets
│   └── README.md               # Service-specific notes (where relevant)
```

There is **no** per-host subdirectory — services are named by what they are, and the host they land on is decided by `docker_services` / `systemd_services` lists in `ansible/inventory/host_vars/<host>.yml`.

## Service inventory

| Service | Type | Host(s) | Notes |
|---|---|---|---|
| caddy | Native (apt) | helsinki-a | Reverse proxy. Caddyfile lives here. |
| authelia | Docker | helsinki-a | SSO, plus MariaDB and LLDAP sidecars |
| bitwarden | Docker | helsinki-a | Vaultwarden + MariaDB |
| forgejo | Docker | helsinki-a | Git forge |
| poste-io | Docker | nuremberg-a | Mail |
| n8n | Docker | nuremberg-a | Workflow automation |
| jellyseerr | Docker | london-b | Plex request manager |
| navidrome | Docker | london-b | Music streaming |
| bookshelf | Docker | london-b | Ebook/audiobook manager (Readarr revival) |
| slskd | Docker | london-b | Soulseek client |
| smartctl-exporter | Docker | london-b, copenhagen-a | SMART metrics |
| plex-exporter | Docker | london-b | Plex metrics |
| octopus-exporter | Docker | london-c | Octopus Energy metrics |
| minecraft | Docker | copenhagen-a | PaperMC server |
| radarr / sonarr / lidarr / prowlarr / whisparr | systemd | london-b | *Arr stack (systemd unit files here) |
| transmission | systemd | london-b | Config files (the daemon itself is apt) |
| samba / vsftpd | systemd | london-b | File-sharing config |
| ollama | systemd | london-b | Custom unit + binary install |
| mangos-realmd / mangos-world / mangos-zero | systemd | copenhagen-a | MaNGOS WoW server |
| promtail | systemd | (currently unused; historical) | Log shipper, replaced by Alloy |
| status-page | Cron script | helsinki-a | `update-status.sh` writes `/srv/status` |
| rc.d | FreeBSD rc.conf | (historical) | Snapshot of london-a's old FreeBSD setup |

## Conventions

- **Compose stacks** live at `<service>/docker-compose.yml` and are deployed to `/opt/docker/<service>/` on the target host.
- **Systemd units** are copied to `/etc/systemd/system/<service>.service` by the `media_stack` or `systemd_services` role.
- **Secrets** are SOPS-encrypted (`*.enc.yml`) and decrypted into place at deploy time.

## Adding a new service

See [docs/getting-started.md](../../docs/getting-started.md#adding-a-new-service) for the end-to-end flow (compose → host_vars → Caddy → DNS → docs).
