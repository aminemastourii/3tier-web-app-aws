resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "internet gateway attached to dev vpc"
  }
}



#public-subnet-az-1
resource "aws_subnet" "public-subnet-az1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public subnet az-1"
  }
}

#public-subnet-az-2
resource "aws_subnet" "public-subnet-az2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az-2"
  }
}

#private-subnet-server-az-1
resource "aws_subnet" "private-subnet-server-az1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet for server in az-1"
  }
}

#private-subnet-server-az-2
resource "aws_subnet" "private-subnet-server-az2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet for server in az-2"
  }
}


#private-subnet-rdsStandBy-az-2
resource "aws_subnet" "private-subnet-rds-az1" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet for the rds StandBy in az-1"
  }
}


#private-subnet-rds-az-2
resource "aws_subnet" "private-subnet-rds-az2" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private subnet for the rds in az-2"
  }
}
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "private route table for the public subnets shared by the two AZ to enable traffic through the IGW"
  }
}

#associate public route table the public subnet in AZ1
resource "aws_route_table_association" "public-route-table-association-az1" {
  subnet_id      = aws_subnet.public-subnet-az1.id
  route_table_id = aws_route_table.public-route-table.id
}

#associate public route table the public subnet in AZ2
resource "aws_route_table_association" "public-route-table-association-az2" {
  subnet_id      = aws_subnet.public-subnet-az2.id
  route_table_id = aws_route_table.public-route-table.id
}