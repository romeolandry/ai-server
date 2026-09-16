ANSIBLE_PLAYBOOK := ansible-playbook
INVENTORY := inventory/production/hosts.yml
HETZNER_INVENTORY := inventory/hetzner/hosts.yml
PLAYBOOK := playbooks/site.yml
PROVISION_PLAYBOOK := playbooks/provision_hetzner.yml
CLEAR_HETZNER_PLAYBOOK := playbooks/clear_hetzner.yml

.PHONY: help proof syntax check apply full hetzner-syntax hetzner-check hetzner-apply hetzner-full provision-syntax provision-run provision-full clear-hetzner-syntax clear-hetzner-run clear-hetzner-full

help:
	@echo "Makefile targets:"
	@echo "  proof             - run ansible-lint if available (fast pre-check)"
	@echo "  syntax            - run ansible --syntax-check on the default inventory"
	@echo "  check             - run playbook in --check mode for the default inventory"
	@echo "  apply             - run the playbook for the default inventory"
	@echo "  full              - run syntax -> check -> apply for the default inventory"
	@echo "  hetzner-syntax    - run ansible --syntax-check for the Hetzner inventory"
	@echo "  hetzner-check     - run playbook in --check mode for the Hetzner inventory"
	@echo "  hetzner-apply     - run the playbook for the Hetzner inventory"
	@echo "  hetzner-full      - run syntax -> check -> apply for the Hetzner inventory"
	@echo "  provision-syntax  - syntax-check the Hetzner VPS provisioning playbook"
	@echo "  provision-run     - create a new Hetzner VPS and deploy the app"
	@echo "  provision-full    - syntax-check + run the Hetzner provisioning playbook"
	@echo "  clear-hetzner-syntax - syntax-check the Hetzner VPS deletion playbook"
	@echo "  clear-hetzner-run    - delete the Hetzner VPS named by SERVER_NAME"
	@echo "  clear-hetzner-full   - syntax-check + run the Hetzner deletion playbook"

# Include .env file if it exists
ifneq ( $(wildcard .env), )
    include .env
    export $(shell sed 's/=.*//' .env)
endif

proof:
	@command -v ansible-lint >/dev/null 2>&1 && ansible-lint $(PLAYBOOK) || \
	{ echo "ansible-lint not found, skipping proof (install with: pip install ansible-lint)"; exit 0; }

syntax:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(PLAYBOOK) --syntax-check

check:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(PLAYBOOK) --check

apply:
	$(ANSIBLE_PLAYBOOK) -i $(INVENTORY) $(PLAYBOOK)

full: syntax check apply
	@echo "Full run completed."

hetzner-syntax:
	$(ANSIBLE_PLAYBOOK) -i $(HETZNER_INVENTORY) $(PLAYBOOK) --syntax-check

hetzner-check:
	$(ANSIBLE_PLAYBOOK) -i $(HETZNER_INVENTORY) $(PLAYBOOK) --check

hetzner-apply:
	$(ANSIBLE_PLAYBOOK) -i $(HETZNER_INVENTORY) $(PLAYBOOK)

hetzner-full: hetzner-syntax hetzner-check hetzner-apply
	@echo "Hetzner full run completed."

provision-syntax:
	$(ANSIBLE_PLAYBOOK) $(PROVISION_PLAYBOOK) --syntax-check

provision-run:
	$(ANSIBLE_PLAYBOOK) $(PROVISION_PLAYBOOK)

provision-full: provision-syntax provision-run
	@echo "Hetzner VPS provisioning completed."

clear-hetzner-syntax:
	$(ANSIBLE_PLAYBOOK) $(CLEAR_HETZNER_PLAYBOOK) --syntax-check

clear-hetzner-run:
	$(ANSIBLE_PLAYBOOK) $(CLEAR_HETZNER_PLAYBOOK)

clear-hetzner-full: clear-hetzner-syntax clear-hetzner-run
	@echo "Hetzner VPS deletion completed."
