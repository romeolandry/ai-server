ANSIBLE_PLAYBOOK := ansible-playbook
INVENTORY := inventory/production/hosts.yml
PLAYBOOK := playbooks/site.yml

.PHONY: help proof syntax check apply full

help:
	@echo "Makefile targets:"
	@echo "  proof   - run ansible-lint if available (fast pre-check)"
	@echo "  syntax  - run ansible --syntax-check on the playbook"
	@echo "  check   - run playbook in --check (dry-run) mode"
	@echo "  apply   - run the playbook for real"
	@echo "  full    - run syntax -> check -> apply (stops on failure)"

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
