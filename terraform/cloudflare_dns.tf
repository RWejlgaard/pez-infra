resource "cloudflare_zone" "pez-sh" {
  account = {
    id = cloudflare_account.this.id
  }
  name = "pez.sh"
}

# =============================================================================
# A Records
# =============================================================================

resource "cloudflare_dns_record" "apps" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "apps"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "auth" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "auth"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "bitwarden" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "bitwarden"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "download" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "download"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "git" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "git"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "grafana" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "grafana"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "helsinki-a" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "helsinki-a"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "jellyfin" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "jellyfin"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "jellyfin-requests" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "jellyfin-requests"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "ldap" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "ldap"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "lidarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "lidarr"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "mail-a" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "mail"
  type    = "A"
  content = hcloud_server.nuremberg-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "minecraft" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "minecraft"
  type    = "A"
  content = "83.94.248.182"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "music" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "music"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "naveen" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "naveen"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "root" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "plex" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "plex"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "prometheus" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "prometheus"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "prowlarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "prowlarr"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "radarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "radarr"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "readarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "readarr"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "request" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "request"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "rss" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "rss"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "sonarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "sonarr"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "soulseek" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "soulseek"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "status" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "status"
  type    = "A"
  content = hcloud_server.helsinki-a.ipv4_address
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "wow" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "wow"
  type    = "A"
  content = "83.94.248.182"
  proxied = false
  ttl     = 1
}

# =============================================================================
# AAAA Records
# =============================================================================

resource "cloudflare_dns_record" "mail-aaaa" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "mail"
  type    = "AAAA"
  content = hcloud_server.nuremberg-a.ipv6_address
  proxied = false
  ttl     = 1
}

# =============================================================================
# CNAME Records
# =============================================================================

resource "cloudflare_dns_record" "public" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "public"
  type    = "CNAME"
  content = "public.r2.dev"
  proxied = true
  ttl     = 1
}

# =============================================================================
# HTTPS Records
# =============================================================================

# =============================================================================
# MX Records
# =============================================================================

resource "cloudflare_dns_record" "root-mx-10" {
  zone_id  = cloudflare_zone.pez-sh.id
  name     = "@"
  type     = "MX"
  content  = "mail.pez.sh"
  priority = 10
  ttl      = 1
}

resource "cloudflare_dns_record" "root-mx-20" {
  zone_id  = cloudflare_zone.pez-sh.id
  name     = "@"
  type     = "MX"
  content  = "mail.pez.sh"
  priority = 20
  ttl      = 1
}

# =============================================================================
# PTR Records
# =============================================================================



# =============================================================================
# TXT Records
# =============================================================================

resource "cloudflare_dns_record" "dkim" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "dkim._domainkey"
  type    = "TXT"
  content = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmT/TGkPkfbjleqRYuQoI67/xvM0J5gGmdlzo2jO5qTABz5+nzOS+PefrXkeEZ0IZrpLPKqLyi7K469Ql+HG5wDFDxQRRG7lHJkWJ4tnZgjZWgeszFPhoME74lT6i+j3x29WyxhyzNg0f3NhSwttOe5knmS4zsOb+JK4jShoF9zZkOUCHAZ/vKvYtJdV+8qpmU8wfgyrzN1OWxjHIjzPP8iMD4g0iCfobbvSvWXHYBveCS7b/Nr3jw3E8twtEAUEGYNGd4h0wKNbNagYUsb5My8tMxQQwZf6imKHgCeYC7buH8TvaJHATReeea4Dzj9UzdPgwdbFLiMB/HXlN0GPhlQIDAQAB"
  ttl     = 1
}

resource "cloudflare_dns_record" "dmarc" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "_dmarc"
  type    = "TXT"
  content = "v=DMARC1; p=quarantine; rua=mailto:pez@pez.sh; adkim=r; aspf=r"
  ttl     = 1
}

resource "cloudflare_dns_record" "root-txt-spf" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "TXT"
  content = "v=spf1 ip4:${hcloud_server.nuremberg-a.ipv4_address} ip6:${hcloud_server.nuremberg-a.ipv6_address} -all"
  ttl     = 1
}
