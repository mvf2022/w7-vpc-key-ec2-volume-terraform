// ec2 instance code

resource "aws_instance" "server" {
ami = "ami-0d32a9fe88fce158d"
instance_type = "t3.micro" 
subnet_id = aws_subnet.public1.id
vpc_security_group_ids = [ aws_security_group.web_sg.id]
//key_name = ""
user_data = file("setup.sh")
  
}

// ebs volume

resource "aws_ebs_volume" "ebs" {
  size = 20
  availability_zone = aws_instance.server.availability_zone
tags = {
  name = "Extra-volume"
}
}
resource "aws_volume_attachment" "att" {
  instance_id = aws_instance.server.id
  volume_id = aws_ebs_volume.ebs.id
  device_name = "/dev/sdt"
}
