locals {
  external_sg_name = "${var.cluster_name}-external"
}

resource "aws_security_group" "node_group_external" {
  count = var.create && var.create_component_external ? 1 : 0

  description = "Controls access to external node group on ${var.cluster_name} EKS cluster"
  vpc_id      = var.vpc_id
  name        = local.external_sg_name

  dynamic "ingress" {
    for_each = var.nlb_external_allow_rules
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  ingress {
    cidr_blocks = [var.vpc_cidr_block]
    description = "allow vpc traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  ingress {
    cidr_blocks = var.nlb_external_allowed_cidr_blocks
    description = "allow external traffic from specific CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = local.external_sg_name
  })
}
