
//This is the code for vpc 
resource "aws_vpc" "my-vpc" {
  cidr_block = "172.120.0.0/16"  // class B 65k
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"
  tags = {
    Name = "utc-Vpc"
    env = "Dev"
    app-name = "utc"
    Team = "wdp"
    created_by = "valerie"
  }
}
// internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "utc-IGW"
  }
}
// public subnet creation
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.1.0/24"  // class c  254 ips 
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "utc-public-sub1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.2.0/24"  // class c  254 ips 
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
  Name = "utc-public-sub2"
  }
  depends_on = [ aws_vpc.my-vpc ]   # dependancy 
}
// subnet creation private
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.3.0/24"  // class c  254 ips 
  availability_zone = "us-east-1a"
  tags = {
    Name = "utc-private-sub1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "172.120.4.0/24"  // class c  254 ips 
  availability_zone = "us-east-1b"
  tags = {
    Name = "utc-private-sub2"
  }
}
#nat gateway
resource "aws_eip" "eip" {
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
  tags ={
    Name = "utc-NAT"
  }
}
#route table for private subnet
resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}
// route table public 
resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.my-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

  