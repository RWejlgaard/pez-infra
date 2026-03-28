# Bitwarden

Self-hosted password manager (unified deployment).

- **Host:** helsinki-a
- **URL:** https://bitwarden.pez.sh
- **Image:** `ghcr.io/bitwarden/self-host:beta` (unified container)
- **Database:** MariaDB 10
- **Admin:** pez@pez.sh
- **Config:** `settings.env` (env file, not committed — contains secrets)
- **Data:** Docker volumes (`bitwarden`, `data`)
