resource "hcloud_zone" "pezsh" {
  name = "pez.sh"
  mode = "primary"
}

resource "hcloud_zone_rrset" "A_www" {
  zone = hcloud_zone.pezsh.name
  name = "www"
  type = "A"

  ttl = 300

  labels = {
    key = "value"
  }

  records = [
    { value = "201.78.10.45", comment = "web server 1" },
  ]
}

# =============================================================================
# A Records
# =============================================================================

resource "hcloud_zone_rrset" "A_apps" {
  zone    = hcloud_zone.pezsh.name
  name    = "apps"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_auth" {
  zone    = hcloud_zone.pezsh.name
  name    = "auth"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_bitwarden" {
  zone    = hcloud_zone.pezsh.name
  name    = "bitwarden"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_download" {
  zone    = hcloud_zone.pezsh.name
  name    = "download"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_git" {
  zone    = hcloud_zone.pezsh.name
  name    = "git"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_grafana" {
  zone    = hcloud_zone.pezsh.name
  name    = "grafana"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_helsinki-a" {
  zone    = hcloud_zone.pezsh.name
  name    = "helsinki-a"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_jellyfin" {
  zone    = hcloud_zone.pezsh.name
  name    = "jellyfin"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_jellyfin-requests" {
  zone    = hcloud_zone.pezsh.name
  name    = "jellyfin-requests"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_ldap" {
  zone    = hcloud_zone.pezsh.name
  name    = "ldap"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_lidarr" {
  zone    = hcloud_zone.pezsh.name
  name    = "lidarr"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_mail" {
  zone    = hcloud_zone.pezsh.name
  name    = "mail"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.nuremberg-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_minecraft" {
  zone    = hcloud_zone.pezsh.name
  name    = "minecraft"
  type    = "A"
  ttl     = 300
  records = [{ value = "83.94.248.182" }]
}

resource "hcloud_zone_rrset" "A_music" {
  zone    = hcloud_zone.pezsh.name
  name    = "music"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_naveen" {
  zone    = hcloud_zone.pezsh.name
  name    = "naveen"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_root" {
  zone    = hcloud_zone.pezsh.name
  name    = "@"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_plex" {
  zone    = hcloud_zone.pezsh.name
  name    = "plex"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_prometheus" {
  zone    = hcloud_zone.pezsh.name
  name    = "prometheus"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_prowlarr" {
  zone    = hcloud_zone.pezsh.name
  name    = "prowlarr"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_radarr" {
  zone    = hcloud_zone.pezsh.name
  name    = "radarr"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_readarr" {
  zone    = hcloud_zone.pezsh.name
  name    = "readarr"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_request" {
  zone    = hcloud_zone.pezsh.name
  name    = "request"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_rss" {
  zone    = hcloud_zone.pezsh.name
  name    = "rss"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_sonarr" {
  zone    = hcloud_zone.pezsh.name
  name    = "sonarr"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_soulseek" {
  zone    = hcloud_zone.pezsh.name
  name    = "soulseek"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_status" {
  zone    = hcloud_zone.pezsh.name
  name    = "status"
  type    = "A"
  ttl     = 300
  records = [{ value = hcloud_server.helsinki-a.ipv4_address }]
}

resource "hcloud_zone_rrset" "A_wow" {
  zone    = hcloud_zone.pezsh.name
  name    = "wow"
  type    = "A"
  ttl     = 300
  records = [{ value = "83.94.248.182" }]
}

# =============================================================================
# AAAA Records
# =============================================================================

resource "hcloud_zone_rrset" "AAAA_mail" {
  zone    = hcloud_zone.pezsh.name
  name    = "mail"
  type    = "AAAA"
  ttl     = 300
  records = [{ value = hcloud_server.nuremberg-a.ipv6_address }]
}

# =============================================================================
# CNAME Records
# =============================================================================

resource "hcloud_zone_rrset" "CNAME_public" {
  zone    = hcloud_zone.pezsh.name
  name    = "public"
  type    = "CNAME"
  ttl     = 300
  records = [{ value = "public.r2.dev." }]
}

# =============================================================================
# MX Records
# =============================================================================

resource "hcloud_zone_rrset" "MX_root" {
  zone = hcloud_zone.pezsh.name
  name = "@"
  type = "MX"
  ttl  = 300
  records = [
    { value = "10 mail.pez.sh." },
    { value = "20 mail.pez.sh." },
  ]
}

# =============================================================================
# TXT Records
# =============================================================================

resource "hcloud_zone_rrset" "TXT_dkim" {
  zone    = hcloud_zone.pezsh.name
  name    = "dkim._domainkey"
  type    = "TXT"
  ttl     = 300
  records = [{ value = "\"v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmT/TGkPkfbjleqRYuQoI67/xvM0J5gGmdlzo2jO5qTABz5+nzOS+PefrXkeEZ0IZrpLPKqLyi7K469Ql+HG5wDFDxQRRG7lHJkWJ4tnZgjZWgeszFPhoME74lT6i+j3x29WyxhyzNg0f3NhSwttOe5knmS4zsOb+JK4jShoF9zZkOUCHAZ/vKvYtJdV+8qpmU8wfgyrzN1OWxjHIjzPP8iMD4g0iCfobbvSvWXHYBveCS7b/Nr3jw3E8twtEAUEGYNGd4h0wKNbNagYUsb5My8tMxQQwZf6imKHgCeYC7buH8TvaJHATReeea4Dzj9UzdPgwdbFLiMB/HXlN0GPhlQIDAQAB\"" }]
}

resource "hcloud_zone_rrset" "TXT_dmarc" {
  zone    = hcloud_zone.pezsh.name
  name    = "_dmarc"
  type    = "TXT"
  ttl     = 300
  records = [{ value = "\"v=DMARC1; p=quarantine; rua=mailto:pez@pez.sh; adkim=r; aspf=r\"" }]
}

resource "hcloud_zone_rrset" "TXT_root_spf" {
  zone    = hcloud_zone.pezsh.name
  name    = "@"
  type    = "TXT"
  ttl     = 300
  records = [{ value = "\"v=spf1 ip4:${hcloud_server.nuremberg-a.ipv4_address} ip6:${hcloud_server.nuremberg-a.ipv6_address} -all\"" }]
}
