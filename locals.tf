data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  region          = data.aws_region.current.name
  partition       = data.aws_partition.current.partition

  tags = merge(
    var.tags,
    {
      tf-module-func = "terraform-aws-func-kubernetes"
    }
  )
}
