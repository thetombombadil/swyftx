resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.region
  }
}

resource "aws_subnet" "public" {
  for_each = { for s in var.subnets : s.id => s }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.id

  tags = {
    Name = "public-${each.value.id}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = { for k, s in aws_subnet.public : k => s.id }

  subnet_id      = each.value
  route_table_id = aws_route_table.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.region
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-${var.region}"
  }
}
