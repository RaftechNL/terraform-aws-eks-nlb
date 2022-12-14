variable "create" {
  type        = bool
  default     = true
  description = "Controls if the resources are created or not"
}

variable "create_component_external" {
  type        = bool
  default     = true
  description = "Controls if the external facing resources are created or not"
}

variable "create_component_internal" {
  type        = bool
  default     = true
  description = "Controls if the external facing resources are created or not"
}

variable "create_component_sys" {
  type        = bool
  default     = true
  description = "Controls if the sys resources are created or not"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes <major>.<minor> version to use for the EKS cluster (i.e.: 1.22)"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  default     = true
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = ["0.0.0.0/0"]
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources created by this module"
  default     = {}
}

variable "vpc_id" {
  type        = string
  description = "VPC id where the resources will be deployed"
}

variable "subnet_ids" {
  type = object({
    private = list(string)
    public  = list(string)
  })
  description = "A list of subnets to associate with the eks cluster, load balancer and node groups"
}

variable "vpc_cidr_block" {
  type        = string
  description = "(Optional) List of VPC's CIDR blocks"
}

#nlb_external_allowed_cidr_blocks
variable "nlb_external_allowed_cidr_blocks" {
  type        = list(string)
  description = "(Optional) List of CIDR blocks to allow ingress traffic from external sources ( i.e. Cloudflare ). If we do not specify to allow external access - then we allow from everywhere"
  default     = ["0.0.0.0/0"]
}

#nlb_external_allow_rules
variable "nlb_external_allow_rules" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "(Optional) Inbound security group rules for external nlb security group"
  default     = []
}

# These are used by network loadbalancers as targets
variable "ng_config_ext_int" {
  description = "Configuration for self managed node groups"
  type = object({
    external = object({
      instance_type        = string
      bootstrap_extra_args = string
    })
    internal = object({
      instance_type        = string
      bootstrap_extra_args = string
    })
  })

  default = {
    external = {
      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=networking/ingress-type=ext,networking/ingress=true,node.kubernetes.io/lifecycle=on-demand --register-with-taints=networking/ingress-type=ext:NoSchedule'"
      instance_type        = "t3.medium"
    }
    internal = {
      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=networking/ingress-type=int,networking/ingress=true,node.kubernetes.io/lifecycle=on-demand --register-with-taints=networking/ingress-type=int:NoSchedule'"
      instance_type        = "t3.medium"
    }
  }

}


variable "ng_config_sys" {
  description = "Configuration for EKS managed node group ( sys ) "
  type = object({
    instance_types = list(string)
    labels         = map(string)
    taints = map(object({
      key    = string
      value  = string
      effect = string
    }))
  })

  default = {
    instance_types = ["t3.medium"]
    labels = {
      "node/dedicated" = "sys"
    }
    taints = {
      critical = {
        key    = "CriticalAddonsOnly"
        value  = "true"
        effect = "NO_SCHEDULE"
      }
    }
  }
}

