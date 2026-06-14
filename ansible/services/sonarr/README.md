# Sonarr

TV series management and automated downloading.

## Deployment

- **Host:** london-b
- **Install method:** APT package (`sonarr` v3, mono-based)
- **Service:** `sonarr.service` (in this directory, deployed to
  `/etc/systemd/system/` by the `media_stack` role)
- **Data directory:** `/var/lib/sonarr`
- **Web UI:** `sonarr.pez.sh` (proxied via Caddy on helsinki-a)
- **Managed by:** `media_stack` Ansible role (deploys the unit, then ensures it
  is enabled and started)

## Notes

The APT package ships its own unit at `/usr/lib/systemd/system/sonarr.service`.
The unit here was captured from that running unit and is deployed to
`/etc/systemd/system/sonarr.service`, which overrides the package copy so the
unit lives in IaC alongside the other *arr services (radarr / lidarr /
prowlarr). Because of the override, package updates to the unit no longer apply
automatically — re-capture this file if the package unit changes.

Unlike radarr/lidarr/prowlarr (manually installed `/opt` binaries), Sonarr is
mono-based, so `ExecStart` runs `Sonarr.exe` via `/usr/bin/mono`. To change
User/Group/UMask/-data, edit `sonarr.service` here rather than running
`dpkg-reconfigure -plow sonarr`.

The `media_stack` role also sets up a midnight cron restart
(`systemctl restart sonarr`).
