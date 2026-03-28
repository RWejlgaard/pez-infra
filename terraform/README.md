# Terraform

Infrastructure-as-code for cloud and edge services. Uses [OpenTofu](https://opentofu.org/) (drop-in Terraform replacement).

## What's managed

- **Cloudflare DNS** — All `pez.sh` records (A, CNAME, MX, TXT)

## CI/CD

The original GitHub Actions workflow (`apply.yml`) ran plan on push to master, then applied with manual approval via a `prod` environment gate. This workflow lived in the standalone `pez-terraform` repo and would need adapting for the monorepo structure (e.g., path-filtered triggers).

## Provider versions

| Provider | Source | Version |
|----------|--------|---------|
| Cloudflare | `cloudflare/cloudflare` | `~> 5.18` |
| OpenTofu | — | `>= 1.6.0` |

## Migrated from

This directory replaces the standalone [`pez-terraform`](https://github.com/RWejlgaard/pez-terraform) repo.
