resource "aws_vpc" "newvpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.newvpc.id

  tags = {
    Name = "mynewvpc"
  }
}
resource "aws_subnet" "Publicsubnet1" {
  vpc_id                  = aws_vpc.newvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub1"
  }
}

resource "aws_subnet" "Privatesubnet1" {
  vpc_id            = aws_vpc.newvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = local.av_zone
  tags = {
    Name = "priv1"
  }
}
locals {
  av_zone = "us-east-1a"

}

# resource "aws_eip" "neweip" {

#   depends_on = [ aws_internet_gateway.gw ]
# }



# resource "aws_nat_gateway" "ng1" {
#   allocation_id = aws_eip.neweip.id
#   subnet_id     = aws_subnet.Publicsubnet1.id
#   depends_on=[aws_internet_gateway.gw]
#   tags = {
#     Name = "gw NAT"
#   }
#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.

# }







resource "aws_route_table" "Publicrt" {
  vpc_id = aws_vpc.newvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "pubrt"
  }
}

// route table subnet association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Publicsubnet1.id
  route_table_id = aws_route_table.Publicrt.id
}





resource "aws_route_table" "Privatert" {
  vpc_id = aws_vpc.newvpc.id

  #   route {
  #     cidr_block = "0.0.0.0/0"
  #     gateway_id = aws_nat_gateway.ng1.id
  #   }

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "privrt"
  }
}
// route table subnet association
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.Privatesubnet1.id
  route_table_id = aws_route_table.Privatert.id
}