# Secrets Management

This repo uses [SOPS](https://github.com/getsops/sops) with [age](https://github.com/FiloSottile/age) encryption for secrets. Encrypted files live in the repo alongside the configs they belong to — only the secret values are encrypted, so diffs remain useful.

## Why SOPS + age?

- **age over GPG**: No key expiry, no keyservers, no UID headaches. A single static public key per recipient.
- **SOPS over git-crypt**: Encrypts values, not whole files. You can see the structure of a secrets file without decrypting it. Works with YAML, JSON, ENV, and INI.
- **SOPS over Ansible Vault**: Ansible Vault only works with Ansible. SOPS works everywhere — Terraform (via `terraform-provider-sops`), Docker env files, CI pipelines, scripts.

## File naming convention

Encrypted files use `.enc.` in their extension:

```
services/authelia/config.enc.yml     # encrypted YAML
services/miniflux/miniflux.enc.env   # encrypted env file
terraform/secrets.enc.yaml           # encrypted Terraform vars
ansible/group_vars/all/secrets.enc.yml
```

Plaintext files MUST NOT contain secrets. The `.gitignore` blocks common secret filenames (`secrets.yml`, `vault.yml`, `secret.env`, etc.) as a safety net.

## Setup (one-time)

### Install tools

```bash
# macOS
brew install sops age

# Debian/Ubuntu
apt install age
# SOPS: download from https://github.com/getsops/sops/releases
wget https://github.com/getsops/sops/releases/download/v3.9.4/sops_3.9.4_amd64.deb
dpkg -i sops_3.9.4_amd64.deb

# FreeBSD
pkg install age sops
```

### Generate your age key

```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Output: public key: age1abc123...
```

This file is your private key. **Never commit it.** The `.gitignore` already blocks `keys.txt` and `*.agekey`.

SOPS automatically looks for keys in `~/.config/sops/age/keys.txt` (Linux/macOS) or you can set `SOPS_AGE_KEY_FILE` to point elsewhere.

### Add your public key to `.sops.yaml`

Replace the `age1TODO_PEZ_PUBLIC_KEY` placeholder in `.sops.yaml` with your actual public key. Commit the updated `.sops.yaml`.

## Day-to-day usage

### Create a new encrypted file

```bash
# SOPS picks the right age keys from .sops.yaml based on file path
sops services/authelia/config.enc.yml
# Opens your $EDITOR with a decrypted view. Save and quit to encrypt.
```

### Edit an existing encrypted file

```bash
sops services/authelia/config.enc.yml
```

### Decrypt to stdout (for scripts/debugging)

```bash
sops -d services/authelia/config.enc.yml
```

### Encrypt an existing plaintext file

```bash
# If you have a plaintext file you want to encrypt in-place:
sops -e -i services/miniflux/miniflux.enc.env
```

### Add a new recipient

When someone new needs access (or a new CI key is generated):

1. Get their age public key
2. Add it to the relevant `creation_rules` in `.sops.yaml`
3. Re-encrypt all affected files:

```bash
# Update keys on all encrypted files
find . -name '*.enc.*' -exec sops updatekeys {} \;
```

## CI / GitHub Actions

The CI runner needs to decrypt secrets during deploys. Store the age secret key as a GitHub Actions secret:

1. Generate a CI-specific age key: `age-keygen`
2. Add the **private key** (the `AGE-SECRET-KEY-1...` line) as a GitHub repository secret named `AGE_SECRET_KEY`
3. Add the **public key** to `.sops.yaml` (the CI recipient)

In the workflow:

```yaml
- name: Decrypt secrets
  env:
    SOPS_AGE_KEY: ${{ secrets.AGE_SECRET_KEY }}
  run: |
    sops -d ansible/group_vars/all/secrets.enc.yml > ansible/group_vars/all/secrets.yml
```

The existing `ANSIBLE_VAULT_PASS` secret can be retired once migration to SOPS is complete.

## Terraform integration

Use the [terraform-provider-sops](https://github.com/carlpett/terraform-provider-sops) to read encrypted values directly:

```hcl
provider "sops" {}

data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}

# Use decrypted values
resource "cloudflare_record" "example" {
  value = data.sops_file.secrets.data["cloudflare_api_token"]
}
```

## What gets encrypted

These are the types of secrets expected in this repo:

| Category | Example | Location |
|----------|---------|----------|
| Ansible vault vars | SSH keys, API tokens, passwords | `ansible/group_vars/*/secrets.enc.yml` |
| Docker env files | DB passwords, app secrets | `services/*/service.enc.env` |
| Terraform vars | Cloudflare API token, Azure creds | `terraform/secrets.enc.yaml` |
| Service configs | Authelia JWT secret, LLDAP admin pass | `services/*/config.enc.yml` |

## Security notes

- **Never commit `keys.txt`** or any file containing `AGE-SECRET-KEY`. The `.gitignore` blocks these.
- **Rotate keys** if a machine is compromised: generate new key, update `.sops.yaml`, re-encrypt all files, revoke the old key from `.sops.yaml`.
- **CI key is separate** from personal keys so it can be rotated independently.
- SOPS encrypted files contain metadata about which keys can decrypt them — this is intentional and not a secret.
