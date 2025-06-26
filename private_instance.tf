resource "aws_instance" "private" {
  count                  = 2
  ami                    = "ami-0c101f26f147fa7fd" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[count.index].id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "k8s-private-instance-${count.index + 1}"
  }
}
