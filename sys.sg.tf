locals {
  sys_sg_name = "${var.cluster_name}-sys"
}

resource "aws_security_group" "node_group_sys" {
  count = var.create && var.create_component_sys  ? 1 : 0

  description = "Controls access to sys node group on ${var.cluster_name} EKS cluster"
  vpc_id      = var.vpc_id
  name        = local.sys_sg_name

  ingress {
    description = "allow vpc traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
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
    Name = local.sys_sg_name
  })
}
