# VPC
resource "aws_vpc" "mainVPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "mainVPC"
  }
}
## IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "igw"
  }
}
# public subnet 
resource "aws_subnet" "public_subnet" {
  count                   = length("${var.public_cidr}")
  vpc_id                  = var.vpc_id
  cidr_block              = element("${var.public_cidr}", count.index)
  map_public_ip_on_launch = true
  availability_zone       = element("${var.AZ}", count.index)

  tags = {
    Name = "public_sub_${count.index + 1}"
  }
}

# Create Route table for public subnet
resource "aws_route_table" "publicRT" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "publicroute"
  }
}
# Route table association with public subnets
resource "aws_route_table_association" "as1" {
  count          = length(var.public_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.publicRT.id

}

## elastic ip
resource "aws_eip" "eip1" {
  vpc = true
}
## NAT gateway
resource "aws_nat_gateway" "natgateway" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet.0.id
}

## Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr)
  vpc_id            = var.vpc_id
  cidr_block        = element(var.private_cidr, count.index)
  availability_zone = element(var.AZ, count.index)

  tags = {
    Name = "private_sub_${count.index + 1}"
  }
}

# Create Route table for private subnet
resource "aws_route_table" "privateRT" {
  vpc_id = var.vpc_id

  route {
    nat_gateway_id = aws_nat_gateway.natgateway.id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "privateroute"
  }

}

# Route table association with private subnets
resource "aws_route_table_association" "as2" {
  count          = length(var.private_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.privateRT.id
}

output "vpc_id" {
  value = aws_vpc.mainVPC.id
}
output "pub_sub" {
  value = aws_subnet.public_subnet.*.id
}
output "pri_sub_rds" {
  value = [aws_subnet.private_subnet[2].id, aws_subnet.private_subnet[3].id]
}
output "pri_sub_web" {
  value = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
}
output "pri_sub" {
  value = aws_subnet.private_subnet.*.id
}
output "pri_rds_cidr" {
  value = [var.private_cidr[2],var.private_cidr[3]]
}

# output "public_subnet1" {
#   value = element(aws_subnet.public_subnet.*.id, 1)
# }
# output "public_subnet1" {
#   value = element(aws_subnet.public_subnet.*.id, 1)
# }

# output "public_subnet2" {
#   value = element(aws_subnet.public_subnet.*.id, 2)
# }
