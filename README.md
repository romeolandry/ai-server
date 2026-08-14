# AI Server Ansible Project

This repository provisions a Debian-based AI server with Docker, Caddy, and Ollama. It is designed to run a local LLM service behind a secure HTTPS endpoint and expose the model through a frontend-friendly route.

## Current setup

- Host target: `webservers` -> `app01`
- SSH user: `root`
- Public domain: `https://ai-operator.kcrl-devops.de`
- Default Ollama model: `gemma4:e4b`
- Frontend API URL: `https://ai-operator.kcrl-devops.de/ollama`
- Stack installed by the playbook:
  - `git`
  - `curl`
  - `ca-certificates`
  - `gnupg`
  - `docker-ce`
  - `docker-ce-cli`
  - `containerd.io`
  - `docker-buildx-plugin`
  - `docker-compose-plugin`
  - `caddy`
  - `ollama`

## Key configuration files

- `ansible.cfg` – Ansible defaults and compatibility settings
- `inventory/production/hosts.yml` – target host and inventory variables
- `inventory/production/group_vars/all.yml` – environment-specific host variables
- `group_vars/all.yml` – shared project defaults
- `playbooks/site.yml` – main provisioning playbook
- `roles/common/templates/Caddyfile.j2` – HTTPS reverse proxy and `/ollama` routing

## Variables

The following variables are configurable in the project:

```yaml
ollama_model: gemma4:e4b
ollama_host: 0.0.0.0
ollama_port: 11434
frontend_api_url: https://ai-operator.kcrl-devops.de/ollama
caddy_domain: ai-operator.kcrl-devops.de
caddy_email: kamgoche@yahoo.com
caddy_backend_port: 8080
```

Change any of these values in `group_vars/all.yml` or the active inventory file to adapt the setup.

## Quick start

1. Update the target host and variables if needed.
2. Validate the playbook:

   ```bash
   ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml --syntax-check
   ```

3. Run the full setup:

   ```bash
   ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml
   ```

4. Confirm Ollama is reachable:

   ```bash
   curl http://127.0.0.1:11434/api/tags
   ```

5. Confirm the frontend route is active:

   ```bash
   curl -I https://ai-operator.kcrl-devops.de/ollama
   ```

## Notes

- The Caddy entry point is configured to terminate TLS automatically via Let’s Encrypt.
- Requests under `/ollama` are proxied to the local Ollama service on port `11434`.
- The backend application port is expected to run on `8080` if used behind Caddy.
- The project is intentionally modular and can be extended with additional services or roles.
