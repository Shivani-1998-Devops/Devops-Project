
# ================================
# VPC
# ================================
resource "aws_vpc" "dpw_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "dpw-vpc"
    Environment = "Production"
  }
}

# ================================
# PUBLIC SUBNETS
# ================================
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.dpw_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
    Type = "Public"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.dpw_vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
    Type = "Public"
  }
}

# ================================
# PRIVATE SUBNETS
# ================================
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.dpw_vpc.id
  cidr_block        = "10.1.11.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-subnet-1"
    Type = "Private"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.dpw_vpc.id
  cidr_block        = "10.1.12.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet-2"
    Type = "Private"
  }
}

# ================================
# INTERNET GATEWAY
# ================================
resource "aws_internet_gateway" "dpw_igw" {
  vpc_id = aws_vpc.dpw_vpc.id

  tags = {
    Name = "dpw-igw"
  }
}

# ================================
# ELASTIC IP FOR NAT GATEWAY
# ================================
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# ================================
# NAT GATEWAY
# ================================
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "dpw-nat-gateway"
  }

  depends_on = [aws_internet_gateway.dpw_igw]
}

# ================================
# PUBLIC ROUTE TABLE
# ================================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.dpw_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpw_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# ================================
# PRIVATE ROUTE TABLE
# ================================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.dpw_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# ================================
# PUBLIC ROUTE TABLE ASSOCIATIONS
# ================================
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ================================
# PRIVATE ROUTE TABLE ASSOCIATIONS
# ================================
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# ================================
# SECURITY GROUP
# ================================
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.dpw_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # Change this to your IP for better security
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Jenkins-port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

# ================================
# OUTPUTS
# ================================
output "vpc_id" {
  value = aws_vpc.dpw_vpc.id
}

output "public_subnets" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}