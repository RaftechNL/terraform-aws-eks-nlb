## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.14.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | v19.0.3 |
| <a name="module_external_self_managed_node_group"></a> [external\_self\_managed\_node\_group](#module\_external\_self\_managed\_node\_group) | terraform-aws-modules/eks/aws//modules/self-managed-node-group | v19.0.3 |
| <a name="module_internal_self_managed_node_group"></a> [internal\_self\_managed\_node\_group](#module\_internal\_self\_managed\_node\_group) | terraform-aws-modules/eks/aws//modules/self-managed-node-group | v19.0.3 |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | terraform-aws-modules/eks/aws//modules/karpenter | v19.0.3 |
| <a name="module_nlb_external"></a> [nlb\_external](#module\_nlb\_external) | terraform-aws-modules/alb/aws | 8.2.1 |
| <a name="module_nlb_internal"></a> [nlb\_internal](#module\_nlb\_internal) | terraform-aws-modules/alb/aws | 8.2.1 |
| <a name="module_sys_eks_managed_node_group"></a> [sys\_eks\_managed\_node\_group](#module\_sys\_eks\_managed\_node\_group) | terraform-aws-modules/eks/aws//modules/eks-managed-node-group | v19.0.3 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.node_group_external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node_group_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node_group_sys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_auth_roles"></a> [aws\_auth\_roles](#input\_aws\_auth\_roles) | List of role maps to add to the aws-auth configmap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled | `bool` | n/a | yes |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR blocks which can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.22) | `string` | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Controls if the resources are created or not | `bool` | `true` | no |
| <a name="input_create_component_external"></a> [create\_component\_external](#input\_create\_component\_external) | Controls if the external facing resources are created or not | `bool` | `true` | no |
| <a name="input_create_component_internal"></a> [create\_component\_internal](#input\_create\_component\_internal) | Controls if the external facing resources are created or not | `bool` | `true` | no |
| <a name="input_create_component_sys"></a> [create\_component\_sys](#input\_create\_component\_sys) | Controls if the sys resources are created or not | `bool` | `true` | no |
| <a name="input_ng_config_ext_int"></a> [ng\_config\_ext\_int](#input\_ng\_config\_ext\_int) | Configuration for self managed node groups | <pre>object({<br>    external = object({<br>      instance_type        = string<br>      bootstrap_extra_args = string<br>    })<br>    internal = object({<br>      instance_type        = string<br>      bootstrap_extra_args = string<br>    })<br>  })</pre> | <pre>{<br>  "external": {<br>    "bootstrap_extra_args": "--kubelet-extra-args '--node-labels=networking/ingress-type=ext,networking/ingress=true,node.kubernetes.io/lifecycle=on-demand --register-with-taints=networking/ingress-type=ext:NoSchedule'",<br>    "instance_type": "t3.medium"<br>  },<br>  "internal": {<br>    "bootstrap_extra_args": "--kubelet-extra-args '--node-labels=networking/ingress-type=int,networking/ingress=true,node.kubernetes.io/lifecycle=on-demand --register-with-taints=networking/ingress-type=int:NoSchedule'",<br>    "instance_type": "t3.medium"<br>  }<br>}</pre> | no |
| <a name="input_ng_config_sys"></a> [ng\_config\_sys](#input\_ng\_config\_sys) | Configuration for EKS managed node group ( sys ) | <pre>object({<br>    instance_types = list(string)<br>    labels         = map(string)<br>    taints = map(object({<br>      key    = string<br>      value  = string<br>      effect = string<br>    }))<br>  })</pre> | <pre>{<br>  "instance_types": [<br>    "t3.medium"<br>  ],<br>  "labels": {<br>    "node/dedicated": "sys"<br>  },<br>  "taints": {<br>    "critical": {<br>      "effect": "NO_SCHEDULE",<br>      "key": "CriticalAddonsOnly",<br>      "value": "true"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_nlb_external_allow_rules"></a> [nlb\_external\_allow\_rules](#input\_nlb\_external\_allow\_rules) | (Optional) Inbound security group rules for external nlb security group | <pre>list(object({<br>    description = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_nlb_external_allowed_cidr_blocks"></a> [nlb\_external\_allowed\_cidr\_blocks](#input\_nlb\_external\_allowed\_cidr\_blocks) | (Optional) List of CIDR blocks to allow ingress traffic from external sources ( i.e. Cloudflare ). If we do not specify to allow external access - then we allow from everywhere | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of subnets to associate with the eks cluster, load balancer and node groups | <pre>object({<br>    private = list(string)<br>    public  = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources created by this module | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | (Optional) List of VPC's CIDR blocks | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id where the resources will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | n/a |
| <a name="output_nlb"></a> [nlb](#output\_nlb) | n/a |
| <a name="output_node_group"></a> [node\_group](#output\_node\_group) | n/a |
