# Terraform

Infrastructure-as-code for cloud and edge services. Uses [OpenTofu](https://opentofu.org/) (drop-in Terraform replacement).

## What's managed

- **Hetzner Cloud** — Two servers (`nuremberg-a`, `helsinki-a`), firewalls, and DNS for `pez.sh`
- **Grafana Cloud** — Stack, dashboards, synthetic monitoring checks, alert rules, Fleet collectors and pipelines
- **PagerDuty** — Service, escalation policy, and Grafana integration

## Secrets

Secrets are stored encrypted in `secrets.enc.yaml` via [SOPS](https://github.com/getsops/sops) and decrypted at plan/apply time into `secrets.yaml`. The Makefile handles decryption automatically.

## State

State is stored in a Backblaze B2 bucket (`pez-infra-tfstate`) using an S3-compatible backend. Credentials are read from `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` environment variables — the Makefile exports them from the `backblaze_keyID` / `backblaze_applicationKey` secrets automatically.

## Usage

```sh
make init   # initialize providers and backend
make plan   # preview changes
make apply  # apply changes
make fmt    # format all .tf files
```

## Provider versions

| Provider | Source | Version |
|----------|--------|---------|
| Hetzner Cloud | `hetznercloud/hcloud` | `~> 1.45` |
| Grafana | `grafana/grafana` | `~> 4.35` |
| PagerDuty | `pagerduty/pagerduty` | `~> 3.32` |
| OpenTofu | — | `>= 1.6.0` |
