// security group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group with TCP ports 22, 80, and 8080 open"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow custom app on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-sg"
  }
}

# route table association public
resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpublic.id
}
# route table association private
resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id 
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id 
}