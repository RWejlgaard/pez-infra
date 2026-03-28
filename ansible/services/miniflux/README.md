# Miniflux

Lightweight RSS reader.

- **Host:** london-b
- **URL:** https://rss.pez.sh
- **Database:** PostgreSQL 15 (Alpine)
- **Bind address:** Tailscale IP only (100.84.65.101:8181)
- **Data:** Docker volume (`miniflux-db`)
- **Note:** Passwords templatized — set `MINIFLUX_DB_PASSWORD` and `MINIFLUX_ADMIN_PASSWORD` env vars before deploying
