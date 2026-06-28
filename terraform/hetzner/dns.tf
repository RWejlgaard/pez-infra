resource "hcloud_zone" "pezsh" {
  name = "pez.sh"
  mode = "primary"
}

locals {
  helsinki_a     = hcloud_server.helsinki-a.ipv4_address
  nuremberg_a    = hcloud_server.nuremberg-a.ipv4_address
  nuremberg_aaaa = hcloud_server.nuremberg-a.ipv6_address
  copenhagen     = "83.94.248.182"
  dns_ttl        = 300
}

resource "hcloud_zone_rrset" "A_helsinki_a" {
  for_each = toset([
    "@", "apps", "auth", "bitwarden", "download", "git", "helsinki-a",
    "jellyfin", "jellyfin-requests", "*.k8s", "ldap", "lidarr", "london-a", "music", "naveen",
    "n8n", "plex", "prowlarr", "radarr", "readarr", "request",
    "sonarr", "soulseek", "status",
  ])
  zone    = hcloud_zone.pezsh.name
  name    = each.value
  type    = "A"
  ttl     = local.dns_ttl
  records = [{ value = local.helsinki_a }]
}

resource "hcloud_zone_rrset" "nuremberg_mail" {
  for_each = {
    A    = local.nuremberg_a
    AAAA = local.nuremberg_aaaa
  }
  zone    = hcloud_zone.pezsh.name
  name    = "mail"
  type    = each.key
  ttl     = local.dns_ttl
  records = [{ value = each.value }]
}

resource "hcloud_zone_rrset" "A_copenhagen" {
  for_each = toset(["minecraft", "wow"])
  zone     = hcloud_zone.pezsh.name
  name     = each.value
  type     = "A"
  ttl      = local.dns_ttl
  records  = [{ value = local.copenhagen }]
}

resource "hcloud_zone_rrset" "CNAME_public" {
  zone    = hcloud_zone.pezsh.name
  name    = "public"
  type    = "CNAME"
  ttl     = local.dns_ttl
  records = [{ value = "public.r2.dev." }]
}

resource "hcloud_zone_rrset" "MX_root" {
  zone = hcloud_zone.pezsh.name
  name = "@"
  type = "MX"
  ttl  = local.dns_ttl
  records = [
    { value = "10 mail.pez.sh." },
  ]
}

resource "hcloud_zone_rrset" "TXT_dkim" {
  zone = hcloud_zone.pezsh.name
  name = "dkim._domainkey"
  type = "TXT"
  ttl  = local.dns_ttl
  records = [{
    value = "\"v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmT/TGkPkfbjleqRYuQoI67/xvM0J5gGmdlzo2jO5qTABz5+nzOS+PefrXkeEZ0IZrpLPKqLyi7K469Ql+HG5wDFDxQRRG7lHJkWJ4tnZgjZWgeszFPhoME74lT6i+j3x29WyxhyzNg0f3NhSwttOe5knmS4zsOb+JK4jShoF9zZkOUCHAZ/vKvY\" \"tJdV+8qpmU8wfgyrzN1OWxjHIjzPP8iMD4g0iCfobbvSvWXHYBveCS7b/Nr3jw3E8twtEAUEGYNGd4h0wKNbNagYUsb5My8tMxQQwZf6imKHgCeYC7buH8TvaJHATReeea4Dzj9UzdPgwdbFLiMB/HXlN0GPhlQIDAQAB\""
  }]
}

resource "hcloud_zone_rrset" "TXT_dmarc" {
  zone    = hcloud_zone.pezsh.name
  name    = "_dmarc"
  type    = "TXT"
  ttl     = local.dns_ttl
  records = [{ value = "\"v=DMARC1; p=quarantine; rua=mailto:pez@pez.sh; adkim=r; aspf=r\"" }]
}

resource "hcloud_zone_rrset" "TXT_spf" {
  zone    = hcloud_zone.pezsh.name
  name    = "@"
  type    = "TXT"
  ttl     = local.dns_ttl
  records = [{ value = "\"v=spf1 ip4:${local.nuremberg_a} ip6:${local.nuremberg_aaaa} -all\"" }]
}
