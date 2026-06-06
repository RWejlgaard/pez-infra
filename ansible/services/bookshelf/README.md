# Bookshelf

Ebook/audiobook collection manager — a revival of Readarr. Monitors RSS
feeds, downloads, sorts and renames books via Usenet/BitTorrent.

- **Host:** london-b
- **Port:** 8787
- **Image:** `ghcr.io/pennydreadful/bookshelf:hardcover` (Hardcover metadata; use the `softcover` tag for a Goodreads/Readarr-compatible database)
- **Config:** `/root/bookshelf/` (`:/config`)
- **Book library:** `/hdd/books` (mounted at the same path in the container, on the ZFS pool)

Exposed at **https://readarr.pez.sh** (and `.solutions`) behind Authelia —
the hostname is retained from the retired Readarr service it replaces, with
Caddy reverse-proxying to `london-b:8787`. Authelia gates access via the
`pez_readarr_users` group.
