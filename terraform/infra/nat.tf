# Elastic IP for the NAT gateway
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-nat-eip"
    Environment = var.environment
  }
}

# NAT Gateway - sits in public subnet, allows private subnet
# resources to make outbound internet requests
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name        = "${var.project_name}-nat"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}