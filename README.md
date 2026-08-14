# AI Server Ansible Project

This repository provisions a Debian-based server with the required base packages, Docker Engine with the Docker Compose plugin, and Caddy as the reverse proxy.

## Current setup

- Host target: `webservers` -> `app01`
- SSH user: `root`
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

## Structure

- `ansible.cfg` – default Ansible configuration
- `inventory/production/hosts.yml` – target hosts and groups
- `group_vars/all.yml` – shared variables
- `playbooks/site.yml` – server setup playbook
- `roles/common/` – reusable base-role defaults and tasks

## Quick start

1. Adjust the host definition in `inventory/production/hosts.yml` if needed.
2. Validate the playbook:

   ```bash
   ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml --syntax-check
   ```

3. Run it:

   ```bash
   ansible-playbook -i inventory/production/hosts.yml playbooks/site.yml
   ```

## Notes

- The current inventory uses the public hostname `ai-operator.kcrl-devops.de` for the server.
- The playbook uses Debian/Ubuntu apt repositories and systemd services for Docker and Caddy.
