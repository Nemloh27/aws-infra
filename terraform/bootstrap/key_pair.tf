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