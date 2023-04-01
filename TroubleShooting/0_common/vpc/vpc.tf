# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.200.0.0/16"

  tags = {
    Name                                     = "main"
    "kubernetes.io/cluster/facam-ts-handson" = "shared"
  }
}

# Subnets
resource "aws_subnet" "public" {
  count  = var.number_of_subnets
  vpc_id = aws_vpc.main.id

  cidr_block              = "10.200.${count.index}.0/24"
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                     = "public-${var.azs[count.index]}"
    "kubernetes.io/role/elb"                 = "1"
    "kubernetes.io/cluster/facam-ts-handson" = "shared"
  }
}

resource "aws_subnet" "private" {
  count  = var.number_of_subnets
  vpc_id = aws_vpc.main.id

  cidr_block        = "10.200.10${count.index}.0/24"
  availability_zone = var.azs[count.index]

  tags = {
    Name                                     = "private-${var.azs[count.index]}"
    "kubernetes.io/role/internal-elb"        = "1"
    "kubernetes.io/cluster/facam-ts-handson" = "shared"
  }
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  count  = var.number_of_subnets
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "private-${var.azs[count.index]}-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.number_of_subnets
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = var.number_of_subnets
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Gateways
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "igw-main"
    Purpose = "fast campus handson"
  }
}

resource "aws_eip" "nat" {
  count = var.number_of_subnets
  vpc   = true

  tags = {
    Name    = "nat-eip"
    Purpose = "fast campus handson"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.number_of_subnets
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name    = "natgw-main-${count.index}"
    Purpose = "fast campus handson"
  }
}
