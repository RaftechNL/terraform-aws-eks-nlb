module "internal_self_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/self-managed-node-group"
  version = "v19.0.3"
  create  = var.create && var.create_component_internal

  name                = "${var.cluster_name}-ng-internal"  
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_auth_base64 = module.eks.cluster_certificate_authority_data

  subnet_ids = var.subnet_ids.private

  vpc_security_group_ids = [
    module.eks.cluster_primary_security_group_id,
    module.eks.cluster_security_group_id,
    aws_security_group.node_group_internal[0].id,
  ]

  iam_role_use_name_prefix = false
  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
  }

  min_size      = 3
  max_size      = 3
  desired_size  = 3

  instance_type        = var.ng_config_ext_int.internal.instance_type
  bootstrap_extra_args = var.ng_config_ext_int.internal.bootstrap_extra_args
  
  target_group_arns = module.nlb_internal.target_group_arns

  tags = merge(local.tags, {})
}
