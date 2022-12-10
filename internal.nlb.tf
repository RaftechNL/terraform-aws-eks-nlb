module "nlb_internal" {
  source    = "terraform-aws-modules/alb/aws"
  version   = "8.2.1"
  create_lb = var.create && var.create_component_internal

  name = "nlb-int-${var.cluster_name}"

  load_balancer_type = "network"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids.private

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  target_groups = [
    # With the following target group we are using SSL passthrough and we will make sure 
    # that the ingress contain appropiate certificate ( and DNS entry ) using operators on k8s
    #
    # preserve_client_ip is enabled by default for instances
    {
      name                 = "nlb-int-${var.cluster_name}-http"
      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
    },
    {
      name                 = "nlb-int-${var.cluster_name}-https"
      backend_protocol     = "TCP"
      backend_port         = 443
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
    },
  ]

  #  internal listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 1
    },
  ]

  target_group_tags = merge({}, local.tags)

  lb_tags = merge({
    "lb-scope" = "internal"
    "lb-type"  = "nlb"
    },
    local.tags
  )

  tags = local.tags
}
