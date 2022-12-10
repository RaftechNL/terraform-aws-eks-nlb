locals {
  internal_sg_name = "${var.cluster_name}-internal"
}

resource "aws_security_group" "node_group_internal" {
  count = var.create && create_component_internal ? 1 : 0

  description = "Controls access to internal node group on ${var.cluster_name} EKS cluster"
  vpc_id      = var.vpc_id
  name        = local.internal_sg_name

  ingress {
    description = "allow vpc traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    description = "allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = local.internal_sg_name
  })
}
