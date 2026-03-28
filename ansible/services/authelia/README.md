# Authelia

SSO authentication portal with LLDAP directory and MariaDB backend.

- **Host:** helsinki-a
- **URL:** https://auth.pez.sh (integrated via Caddy forward_auth)
- **Components:**
  - **Authelia** — SSO portal (port 9091, localhost only)
  - **LLDAP** — Lightweight LDAP directory (port 3890 LDAP, port 17170 web UI)
  - **MariaDB 11** — Session/config storage
- **Config:** `/root/authelia/config/`
- **Secrets:** `/root/authelia/secrets/` (JWT, session, encryption keys, passwords)
- **LDAP base DN:** `dc=pez,dc=sh`
