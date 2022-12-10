module "sys_eks_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "v19.0.3"
  create  = var.create

  name                = "${var.cluster_name}-ng-sys"    
  cluster_name        = var.cluster_name
  cluster_version     = var.cluster_version
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_auth_base64 = module.eks.cluster_certificate_authority_data

  subnet_ids = var.subnet_ids.private

  vpc_security_group_ids = [
    module.eks.cluster_primary_security_group_id,
    module.eks.cluster_security_group_id,
    try(aws_security_group.node_group_sys[0].id, null),
  ]

  iam_role_use_name_prefix = false
  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore",
  }

  labels = {
    "node.amv.devops/dedicated" = "sys"
  }

  taints = {
    critical = {
      key    = "CriticalAddonsOnly"
      value  = "true"
      effect = "NO_SCHEDULE"
    }
  }

  # We use 3 nodes to support the critical pods across the whole cluster.
  min_size     = 3
  max_size     = 3
  desired_size = 3
  instance_types = [
    "m5.large", # This size is sufficient for the system pods.
  ]

  tags = merge(local.tags, {
    "karpenter.sh/discovery/${var.cluster_name}" = var.cluster_name
  })
}


# An IAM role for service accounts (IRSA) with a narrowly scoped IAM policy for the Karpenter 
# controller to utilize using format of "KarpenterIRSA-${module.eks.cluster_name}" for name
#
# An IAM instance profile for the nodes created by Karpenter to utilize
#
# Note: This setup will utilize the existing IAM role created by the EKS Managed Node group 
# which means the role is already populated in the aws-auth configmap and no further updates are required.
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "v19.0.3"

  cluster_name = module.eks.cluster_name

  create                  = var.create
  create_instance_profile = var.create
  create_irsa             = var.create

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]
  irsa_name                       = "KarpenterController-${module.eks.cluster_name}"
  irsa_use_name_prefix            = false

  iam_role_additional_policies = [
    "arn:${local.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  # This attaches us to existing node group where IAM role for our instance profile
  create_iam_role          = false
  iam_role_name            = "KarpenterNodeInstanceProfile-${module.eks.cluster_name}"
  iam_role_arn             = module.sys_eks_managed_node_group.iam_role_arn
  iam_role_use_name_prefix = false

  tags = merge(local.tags, {})
}
