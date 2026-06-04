.PHONY: deploy deploy-check deploy-host update-all update-linux docker-status reboot ping deps

# Full fleet deploy
deploy:
	ansible-playbook deploy.yml

# Dry run (check + diff, no changes)
deploy-check:
	ansible-playbook deploy.yml --check --diff

# Deploy single host: make deploy-host HOST=helsinki-a
deploy-host:
	ansible-playbook deploy.yml --limit $(HOST)

# Update all packages across the fleet
update-all:
	ansible-playbook playbooks/update-all.yml

# Update Linux hosts only (apt + apk)
update-linux:
	ansible-playbook playbooks/update-linux.yml

# Show Docker container status
docker-status:
	ansible-playbook playbooks/docker-status.yml

# Reboot a specific host: make reboot HOST=copenhagen-c
reboot:
	ansible-playbook playbooks/reboot.yml --limit $(HOST)

# Ping all hosts
ping:
	ansible all -m ping

# Install Ansible Galaxy dependencies
deps:
	ansible-galaxy install -r requirements.yml
