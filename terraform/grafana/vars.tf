variable "plex_token" {
  type        = string
  sensitive   = true
  description = "Plex API token used as a header in the synthetic monitoring check for plex.pez.sh"
}
