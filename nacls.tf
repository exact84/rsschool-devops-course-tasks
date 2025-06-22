// создание ACL и привязка к подсетям
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  subnet_ids = concat(
    aws_subnet.public[*].id,
    aws_subnet.private[*].id
  )

  tags = {
    Name = "k8s-nacl"
  }
}

resource "aws_network_acl_rule" "ingress_all_from_vpc" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "egress_all_to_anywhere" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "ingress_ssh_from_anywhere" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}
