output "cluster" {
  value = module.eks
}

output "node_group" {
  value = {

    "external" = module.external_self_managed_node_group
    "internal" = module.internal_self_managed_node_group
    "sys"      = module.sys_eks_managed_node_group

  }
}

output "nlb" {
  value = {
    "external" = module.nlb_external
    "internal" = module.nlb_internal
  }
}

