resource "cloudflare_zone" "pez-sh" {
  account = {
    id = cloudflare_account.this.id
  }
  name = "pez.sh"
}

# =============================================================================
# A Records
# =============================================================================

resource "cloudflare_dns_record" "ecp-dev-0o9lix" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "0o9lix.ecp-dev"
  type    = "A"
  content = "0.0.0.0"
  proxied = false
  ttl     = 300
}

resource "cloudflare_dns_record" "alertmanager" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "alertmanager"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "apps" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "apps"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "auth" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "auth"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "bitwarden" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "bitwarden"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "chimera" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "chimera"
  type    = "A"
  content = "13.43.223.167"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "cloud" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "cloud"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "download" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "download"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "git" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "git"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "gopher" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "gopher"
  type    = "A"
  content = "83.94.248.182"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "grafana" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "grafana"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "helsinki-a" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "helsinki-a"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "jellyfin" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "jellyfin"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "jellyfin-requests" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "jellyfin-requests"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "ldap" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "ldap"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "lidarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "lidarr"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "mail-a" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "mail"
  type    = "A"
  content = "167.235.134.154"
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
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "naveen" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "naveen"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "root" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "plex" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "plex"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "prometheus" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "prometheus"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "prowlarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "prowlarr"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "radarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "radarr"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "readarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "readarr"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "request" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "request"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "rss" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "rss"
  type    = "A"
  content = "65.108.48.44"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "sonarr" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "sonarr"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "soulseek" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "soulseek"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "status" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "status"
  type    = "A"
  content = "65.108.48.44"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "thiswebsitedoesnotexist" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "thiswebsitedoesnotexist"
  type    = "A"
  content = "65.108.48.44"
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "webdav" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "webdav"
  type    = "A"
  content = "65.108.48.44"
  proxied = false
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
  content = "2a01:4f8:1c1e:9c53::1"
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

resource "cloudflare_dns_record" "status-https" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "status"
  type    = "HTTPS"
  data = {
    priority = 100
    target   = "https://pezsolutions.statuspage.io."
    value    = "ipv6hint=\"::1\""
  }
  ttl = 1
}

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
  content = "v=spf1 ip4:167.235.134.154 ip6:2a01:4f8:1c1e:9c53::1 -all"
  ttl     = 1
}

resource "cloudflare_dns_record" "root-txt-protonmail" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "TXT"
  content = "protonmail-verification=66cf5eff60c61c46a0d36b108c5cfbddc4f2eede"
  ttl     = 1
}

resource "cloudflare_dns_record" "root-txt-keybase" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "TXT"
  content = "keybase-site-verification=ur7GwlgtEEPgIZ-2P0fyFsniuu6YwdkluO7N6LkymK0"
  ttl     = 1
}

resource "cloudflare_dns_record" "root-txt-ms" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "TXT"
  content = "MS=ms99554544"
  ttl     = 300
}

resource "cloudflare_dns_record" "root-txt-google" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "TXT"
  content = "google-site-verification=BZD6ITg5SFnc7mQcb9KGkPwhP9gQKDZgw4nrFOZ0Y0w"
  ttl     = 1
}

resource "cloudflare_dns_record" "root-txt-apple" {
  zone_id = cloudflare_zone.pez-sh.id
  name    = "@"
  type    = "TXT"
  content = "apple-domain=1zXuOydmezm51GT8"
  ttl     = 1
}
