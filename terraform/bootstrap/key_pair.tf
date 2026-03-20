# Generate an SSH key pair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the key pair in AWS using the public key
resource "aws_key_pair" "main" {
  key_name   = "devops-training-key"
  public_key = tls_private_key.main.public_key_openssh

  tags = {
    Name = "devops-training-key"
  }
}

# Save the private key to your local machine
resource "local_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = pathexpand("~/.ssh/devops-training.pem")
  file_permission = "0600"
}

# Output the key name so infra can reference it
output "key_pair_name" {
  value = aws_key_pair.main.key_name
}

# Store the private key in Secrets Manager
resource "aws_secretsmanager_secret" "ssh_private_key" {
  name        = "devops-training/ssh-private-key"
  description = "SSH private key for Ansible access to EC2 instances"

  tags = {
    Name = "devops-training-ssh-key"
  }
}

resource "aws_secretsmanager_secret_version" "ssh_private_key" {
  secret_id     = aws_secretsmanager_secret.ssh_private_key.id
  secret_string = tls_private_key.main.private_key_pem
}

# Output the secret ARN so we can reference it
output "ssh_private_key_secret_arn" {
  value       = aws_secretsmanager_secret.ssh_private_key.arn
  description = "ARN of the SSH private key secret in Secrets Manager"
}