output "server_ips" {
  description = "Public IPv4 addresses of all managed servers"
  value = {
    nuremberg_a = hcloud_server.nuremberg-a.ipv4_address
    helsinki_a  = hcloud_server.helsinki-a.ipv4_address
  }
}

output "dns_zone" {
  description = "The managed DNS zone name"
  value       = hcloud_zone.pezsh.name
}
