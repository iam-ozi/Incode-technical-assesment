# Create VPC01
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc1_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-vpc1"
  })
}

# Create VPC02
resource "aws_vpc" "vpc2" {
  cidr_block           = var.vpc2_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-vpc2"
  })
}

# Internet Gateway for VPC01
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-igw"
  })
}

# Public subnets in VPC01
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-public-${count.index}"
  })
}

# Private subnets in VPC01
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-private-${count.index}"
  })
}

# Public route table & association
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc1.id
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-public-rt"
  })
}
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# NAT Gateway & EIP for private subnets
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-nat-eip"
  })
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-nat"
  })
}

# Private route table & association
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-private-rt"
  })
}
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# VPC Peering between VPC01 and VPC02
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.vpc1.id
  peer_vpc_id   = aws_vpc.vpc2.id
  peer_region   = var.peer_region
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-peer"
  })
}

# Routes in VPC01 route tables pointing to VPC02
resource "aws_route" "vpc1_to_vpc2_public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
resource "aws_route" "vpc1_to_vpc2_private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Route in VPC02's default (main) route table back to VPC01
resource "aws_route" "vpc2_to_vpc1" {
  route_table_id            = aws_vpc.vpc2.default_route_table_id
  destination_cidr_block    = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# ----------------------------------------------------
# Internet Gateway for VPC02 (public Internet access)
# ----------------------------------------------------
resource "aws_internet_gateway" "igw2" {
  vpc_id = aws_vpc.vpc2.id
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-vpc2-igw"
  })
}

# Public subnets in VPC02
resource "aws_subnet" "public_vpc2" {
  count                   = length(var.vpc2_public_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = var.vpc2_public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-vpc2-public-${count.index}"
  })
}

# Route table for VPC02 public subnets
resource "aws_route_table" "public_vpc2_rt" {
  vpc_id = aws_vpc.vpc2.id
  tags = merge(var.tags, {
    Name = "${var.tags["Name"]}-vpc2-public-rt"
  })
}

resource "aws_route" "public_vpc2_internet" {
  route_table_id         = aws_route_table.public_vpc2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw2.id
}

resource "aws_route_table_association" "public_vpc2_assoc" {
  count          = length(aws_subnet.public_vpc2)
  subnet_id      = aws_subnet.public_vpc2[count.index].id
  route_table_id = aws_route_table.public_vpc2_rt.id
}

