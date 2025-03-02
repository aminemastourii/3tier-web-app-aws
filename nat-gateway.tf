resource "aws_eip" "eip1" {
  domain = "vpc"
 tags = {
   Name="elastic ip for the nat gateway in AZ-1"
 }
}

resource "aws_eip" "eip2" {
  domain = "vpc"
 tags = {
   Name="elastic ip for the nat gateway in AZ-2"
 }
}


resource "aws_nat_gateway" "natgateway-1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public-subnet-az1.id

  tags = {
    Name = "Nat gateway in AZ-1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_nat_gateway" "natgateway-2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public-subnet-az2.id

  tags = {
    Name = "Nat gateway in AZ-2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}
# create private route table az1 and add route through nat gateway az1
# terraform aws create route table
resource "aws_route_table" "private-route-table-az1" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway-1.id
  }

  tags = {
    Name = "private route table az1"
  }
}

# associate private server subnet az1 with private route table az1

resource "aws_route_table_association" "private-subnet-server-az1-route-table-az1-association" {
  subnet_id      = aws_subnet.private-subnet-server-az1.id
  route_table_id = aws_route_table.private-route-table-az1.id
}

# associate private rds subnet az1 with private route table az1
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-rds-az1-private-route-table-az1-association" {
  subnet_id      = aws_subnet.private-subnet-rds-az1.id
  route_table_id = aws_route_table.private-route-table-az1.id
}

# create private route table az2 and add route through nat gateway az2
# terraform aws create route table
resource "aws_route_table" "private-route-table-az2" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway-2.id
  }

  tags = {
    Name = "private route table az2"
  }
}

# associate private server subnet az2 with private route table az2
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-server-az2-route-table-az2-association" {
  subnet_id      = aws_subnet.private-subnet-server-az2.id
  route_table_id = aws_route_table.private-route-table-az2.id
}

# associate private data subnet az2 with private route table az2
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-rds-az2-private-route-table-az2-association" {
  subnet_id      = aws_subnet.private-subnet-rds-az2.id
  route_table_id = aws_route_table.private-route-table-az2.id
}