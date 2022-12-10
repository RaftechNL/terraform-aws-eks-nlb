module "nlb_external" {
  source    = "terraform-aws-modules/alb/aws"
  version   = "8.2.1"
  create_lb = var.create && create_component_external

  name = "nlb-ext-${var.cluster_name}"

  load_balancer_type = "network"
  internal           = false
  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids.public

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  target_groups = [
    # With the following target group we are using SSL passthrough and we will make sure 
    # that the ingress contain appropiate certificate ( and DNS entry ) using operators on k8s
    #
    # preserve_client_ip is enabled by default for instances
    {
      name                 = "nlb-ext-${var.cluster_name}-https"
      backend_protocol     = "TCP"
      backend_port         = 443
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 10
        path                = "/healthz" # This is the default path for the health check used by nginx-ingress
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
    },
  ]

  #  External listeners
  http_tcp_listeners = [
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 0
    },
  ]

  target_group_tags = merge({}, local.tags)

  lb_tags = merge({
    "lb-scope" = "external"
    "lb-type"  = "nlb"
    },
    local.tags
  )

  tags = local.tags
}
