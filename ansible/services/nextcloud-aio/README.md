# Nextcloud AIO

All-in-one Nextcloud deployment (self-managed containers).

- **Host:** london-b
- **URL:** https://cloud.pez.sh
- **Admin port:** 8080 (mastercontainer management UI)
- **Apache port:** 11000 (proxied by Caddy on helsinki-a)
- **Data:** Docker volume (`nextcloud_aio_mastercontainer`)
- **Note:** The mastercontainer spawns and manages its own sub-containers (database, redis, apache, etc.)
