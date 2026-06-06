# Bookshelf

Ebook/audiobook collection manager — a revival of Readarr. Monitors RSS
feeds, downloads, sorts and renames books via Usenet/BitTorrent.

- **Host:** london-b
- **Port:** 8787
- **Image:** `ghcr.io/pennydreadful/bookshelf:hardcover` (Hardcover metadata; use the `softcover` tag for a Goodreads/Readarr-compatible database)
- **Config:** `/root/bookshelf/` (`:/config`)
- **Book library:** `/hdd/books` (mounted at the same path in the container, on the ZFS pool)

Reachable over Tailscale at `http://london-b:8787`. Not exposed publicly
(no Caddy/DNS entry).
