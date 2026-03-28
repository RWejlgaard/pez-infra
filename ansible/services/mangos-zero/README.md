# MaNGOS Zero (Vanilla WoW)

Classic WoW private server running on **copenhagen-a**.

## Components

- **mangosd** — World server (`mangos-world.service`)
- **realmd** — Authentication/realm server (`mangos-realmd.service`)
- **MariaDB** — Database backend (system service)

## Config Files

| File | Description |
|------|-------------|
| `etc/mangosd.conf` | World server configuration |
| `etc/realmd.conf` | Realm server configuration |
| `etc/ahbot.conf` | Auction house bot configuration |
| `etc/aiplayerbot.conf` | AI playerbot configuration |

Config files use `{{ mangos_db_password }}` as a placeholder for the database password.
The actual password is stored in `ansible/group_vars/all/secrets.enc.yaml`.

## Paths on copenhagen-a

- Binary: `/home/mangos/mangos/zero/bin/`
- Config: `/home/mangos/mangos/zero/etc/`
- User: `mangos:mangos`

## Systemd Services

Service files are in:
- `../mangos-realmd/mangos-realmd.service`
- `../mangos-world/mangos-world.service`
