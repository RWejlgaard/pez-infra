# nuremberg-a

Dedicated mail server. One job, does it well.

## Overview

| | |
|---|---|
| **Location** | Hetzner Cloud (Nuremberg) |
| **OS** | Debian 13 (Trixie) |
| **Tailscale IP** | 100.70.180.24 |
| **Role** | Mail server (poste.io) |
| **Provider** | Hetzner Cloud VPS |

## Services

| Service | Ports | Deployment |
|---------|-------|-----------|
| poste.io | 25, 80, 110, 143, 443, 465, 587, 993, 995 | Docker |

poste.io is a batteries-included mail server that bundles postfix, dovecot, rspamd, and webmail into a single Docker container. No juggling separate containers for each mail component.

The compose definition lives at `ansible/services/poste-io/docker-compose.yml` and is deployed via the `docker_services` Ansible role (see `ansible/inventory/host_vars/nuremberg-a.yml`).

## Why a separate server

Mail lives on its own VPS to isolate its IP reputation. If the IP gets flagged for any reason, it doesn't affect the rest of the infrastructure. And if something else gets flagged, it doesn't affect mail deliverability.

## DNS

Mail-related DNS records are managed via Cloudflare (Terraform):

- **MX** record for inbound mail routing
- **SPF** for sender verification
- **DKIM** for message signing
- **DMARC** for policy enforcement

## Firewall

Managed by Hetzner Cloud firewall rules (Terraform, `terraform/hetzner/firewall.tf`). Mail ports are exposed via Docker port mappings in `ansible/services/poste-io/docker-compose.yml`.
