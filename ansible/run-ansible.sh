#!/bin/bash
set -e

echo "Fetching bastion IP from Terraform..."
export BASTION_IP=$(cd ../terraform/infra && terraform output -raw bastion_public_ip)
echo "Bastion IP: $BASTION_IP"

echo "Retrieving SSH key from Secrets Manager..."
aws secretsmanager get-secret-value \
  --secret-id devops-training/ssh-private-key \
  --query SecretString \
  --output text > /tmp/devops-training.pem
chmod 600 /tmp/devops-training.pem
echo "SSH key retrieved successfully"

echo "Loading SSH key into agent..."
eval $(ssh-agent -s)
ssh-add /tmp/devops-training.pem
echo "SSH key loaded"

# Export agent variables so child processes inherit them
export SSH_AUTH_SOCK
export SSH_AGENT_PID

echo "Running Ansible playbook..."
cd "$(dirname "$0")"
ansible-playbook playbook.yml \
  --private-key /tmp/devops-training.pem

echo "Cleaning up..."
rm -f /tmp/devops-training.pem
kill $SSH_AGENT_PID 2>/dev/null || true
echo "Done"