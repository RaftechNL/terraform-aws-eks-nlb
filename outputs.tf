output "cluster" {
  value = module.eks
  description = "Contains all outputs from the EKS modules"
}

output "node_group" {
  value = {

    "external" = module.external_self_managed_node_group
    "internal" = module.internal_self_managed_node_group
    "sys"      = module.sys_eks_managed_node_group

  }

  description = "Contains all outputs from creating of the node groups"
}

output "nlb" {
  value = {
    "external" = module.nlb_external
    "internal" = module.nlb_internal
  }

  description = "Contains all outputs from creating internal/external loadbalancers"
}

