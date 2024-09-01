#
# Create Load Balancer
#
resource "aws_lb" "main" {
  name               = format("%s-lb", var.project_name)
  internal           = var.load_balancer_internal
  load_balancer_type = var.load_balancer_type

  subnets = [
    data.aws_ssm_parameter.subnet_public_1a.value,
    data.aws_ssm_parameter.subnet_public_1b.value,
    data.aws_ssm_parameter.subnet_public_1c.value
  ]

  security_groups = [aws_security_group.sg_lb.id]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
}

#
# Create default load balancer listener with fixed response
#
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Linuxtips"
      status_code  = "200"
    }
  }
}
