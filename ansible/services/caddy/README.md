# Caddy

Reverse proxy and TLS termination for all homelab services.
Runs on **helsinki-a** (`100.67.6.27`) as a system service (not Docker).

Replaces the standalone `pez-proxy` repo.

## Structure

```
services/caddy/
├── Caddyfile           # Live config captured from helsinki-a
├── Caddyfile.template  # Templatized version with variable placeholders
└── README.md
```

## How It Works

Helsinki-a sits behind Cloudflare DNS and acts as the single entry point for all
`*.pez.sh` and `*.pez.solutions` traffic. Caddy handles automatic TLS via
Let's Encrypt/ZeroSSL, then reverse-proxies to backend services over the
Tailscale mesh.

### Traffic Flow

```
Internet → Cloudflare → helsinki-a (Caddy) → Tailscale → backend host:port
```

### Admin API

Caddy's admin API listens on `100.67.6.27:2019` (Tailscale-only, not
publicly exposed). Useful for config reloads without downtime:

```bash
caddy reload --config /etc/caddy/Caddyfile
# or via API:
curl http://100.67.6.27:2019/config/
```

### Metrics

Caddy exposes Prometheus metrics with `per_host` granularity. Scraped by
Prometheus on london-a.

## Authelia Forward Auth Pattern

Most admin-facing services are protected by [Authelia](https://www.authelia.com/)
SSO. Authelia runs on helsinki-a itself (`localhost:9091`) alongside an LLDAP
directory and MariaDB backend (see `services/authelia/`).

### How forward_auth Works

Caddy's `forward_auth` directive intercepts every request before it reaches
the upstream. It sends a subrequest to Authelia's verification endpoint:

```
forward_auth localhost:9091 {
    uri /api/authz/forward-auth
    copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
}
```

**Flow:**

1. Client requests `https://grafana.pez.sh/some/page`
2. Caddy sends a verification subrequest to `localhost:9091/api/authz/forward-auth`
3. Authelia checks the session cookie:
   - **Valid session** → returns 200; Caddy copies identity headers (`Remote-User`,
     `Remote-Groups`, `Remote-Name`, `Remote-Email`) and forwards to the upstream
   - **No/expired session** → returns 401 with redirect; Caddy sends user to
     `auth.pez.sh` to log in via Authelia's portal
4. After login, Authelia sets a session cookie and redirects back to the
   original URL

### Which Services Use Authelia

| Service | Auth | Reason |
|---------|------|--------|
| Grafana, Prometheus | Authelia | Admin dashboards |
| Radarr, Sonarr, Lidarr, Readarr | Authelia | Media management |
| Prowlarr, Transmission (download) | Authelia | Download tools |
| slskd (Soulseek) | Authelia | P2P client |
| Miniflux (RSS) | Authelia | RSS reader |
| Apps dashboard | Authelia | Internal apps page |
| Jellyfin, Plex | Own auth | Have built-in user management |
| Overseerr, Jellyseerr | Own auth | Have built-in user management |
| Navidrome (music) | No auth* | Accessible directly |
| Bitwarden | Own auth | Has built-in vault auth |
| Forgejo (git) | Own auth | Has built-in user management |
| Authelia portal | N/A | Is the auth system itself |
| LLDAP web UI | N/A | Admin directory management |

### Template Snippet

The template file uses a Caddy snippet to DRY up the auth block:

```
(authelia) {
    forward_auth localhost:{{AUTHELIA_PORT}} {
        uri /api/authz/forward-auth
        copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
}
```

Usage in a site block: `import authelia`

## Template Variables

The `Caddyfile.template` replaces hardcoded values with placeholders:

| Variable | Current Value | Description |
|----------|--------------|-------------|
| `{{HELSINKI_A_IP}}` | `100.67.6.27` | helsinki-a Tailscale IP |
| `{{LONDON_A_IP}}` | `100.122.219.41` | london-a Tailscale IP |
| `{{LONDON_B_IP}}` | `100.84.65.101` | london-b Tailscale IP |
| `{{AUTHELIA_PORT}}` | `9091` | Authelia verification port |
| `{{DOMAIN_PRIMARY}}` | `pez.sh` | Primary domain |
| `{{DOMAIN_ALT}}` | `pez.solutions` | Alternate domain |

## Notes

- The live Caddyfile on helsinki-a is at `/etc/caddy/Caddyfile`
- Caddy auto-provisions TLS certificates for all listed domains
- Static sites (`pez.sh`, `pez.solutions`, etc.) are served from `/srv/` on helsinki-a
