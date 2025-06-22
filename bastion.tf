resource "aws_instance" "bastion" {
  ami                    = "ami-0c02fb55956c7d316" # Ubuntu 22.04
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public[0].id
  key_name               = "k8s-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}
