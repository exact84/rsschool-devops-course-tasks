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

# Allow SSH to bastion (from anywhere)
resource "aws_network_acl_rule" "ingress_ssh_from_anywhere" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# Allow incoming responses from internet (ephemeral ports)
resource "aws_network_acl_rule" "ingress_ephemeral" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# Allow internal VPC traffic (10.0.0.0/16)
resource "aws_network_acl_rule" "ingress_from_vpc" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 120
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 0
  to_port        = 0
}

# Allow outbound HTTPS (to internet)
resource "aws_network_acl_rule" "egress_https" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true
  protocol       = "6"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Allow outbound DNS (UDP 53)
resource "aws_network_acl_rule" "egress_dns_udp" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 110
  egress         = true
  protocol       = "17" # UDP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

# Allow outbound DNS (TCP fallback)
resource "aws_network_acl_rule" "egress_dns_tcp" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 120
  egress         = true
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 53
  to_port        = 53
}

resource "aws_network_acl_rule" "egress_all" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 130
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# Ingress ICMP from VPC
resource "aws_network_acl_rule" "ingress_icmp" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 130
  egress         = false
  protocol       = "1" # ICMP
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = -1
  to_port        = -1
}

# Egress ICMP to VPC
resource "aws_network_acl_rule" "egress_icmp" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 140
  egress         = true
  protocol       = "1" # ICMP
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = -1
  to_port        = -1
}

resource "aws_network_acl_rule" "ingress_k8s_api" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 160
  egress         = false
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 6443
  to_port        = 6443
}

resource "aws_network_acl_rule" "egress_k8s_api" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 160
  egress         = true
  protocol       = "6" # TCP
  rule_action    = "allow"
  cidr_block     = "10.0.0.0/16"
  from_port      = 6443
  to_port        = 6443
}
