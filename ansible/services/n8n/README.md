# n8n

Workflow automation / orchestration.

- **Host:** nuremberg-a
- **URL:** https://n8n.pez.sh
- **Port:** 5678 (bound to the Tailscale IP `100.70.180.24` only; exposed publicly via Caddy on helsinki-a)
- **Auth:** n8n's own user management (login on first run)
- **Data:** `n8n_data` named volume (`/home/node/.n8n`)
- **Files:** `./local-files` mounted at `/files` inside the container
