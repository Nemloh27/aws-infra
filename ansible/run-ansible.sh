#!/bin/bash
set -e

echo "Fetching bastion IP from Terraform..."
export BASTION_IP=$(cd ../terraform/infra && terraform output -raw bastion_public_ip)
echo "Bastion IP: $BASTION_IP"

echo "Ensuring SSH key is loaded..."
ssh-add ~/.ssh/devops-training.pem 2>/dev/null || true

echo "Running Ansible playbook..."
cd "$(dirname "$0")"
ansible-playbook playbook.yml