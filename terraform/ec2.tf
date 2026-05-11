/*============
------------ EC2 Instances private subnet ------------
============
resource "aws_instance" "private_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "linux-key"

  subnet_id              = aws_subnet.private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = false

  tags = {
    Name = "Private-Server"
  }
}
============================
-------------------- Bastion Host public subnet ------------
============================

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "linux-key"

  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }
}
=========================================
*/


resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "linux-key"

  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  for_each               = toset(["jenkins-master", "jenkins-agent", "ansible"])

  associate_public_ip_address = true

  tags = {
    Name = "${each.key}"
  }
}