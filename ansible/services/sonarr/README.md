# Sonarr

TV series management and automated downloading.

## Deployment

- **Host:** london-b
- **Install method:** APT package (`sonarr` v3, mono-based)
- **Service:** `sonarr.service` (package-managed unit file — do not override)
- **Data directory:** `/var/lib/sonarr`
- **Web UI:** `sonarr.pez.sh` (proxied via Caddy on helsinki-a)
- **Managed by:** `media_stack` Ansible role (ensures service is enabled and started)

## Notes

Unlike radarr/lidarr/readarr/prowlarr (which use manually installed binaries with custom unit files), sonarr is installed via APT and its systemd unit is owned by the package. Use `dpkg-reconfigure -plow sonarr` to change User/Group/UMask settings rather than editing the unit file directly.

The `media_stack` role also sets up a midnight cron restart (`systemctl restart sonarr`).
