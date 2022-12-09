variable "create" {
  type        = bool
  description = "Controls if the resources are created or not"
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

