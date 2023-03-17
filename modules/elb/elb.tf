# Application Load Balancer
resource "aws_lb" "weblb1" {
  name               = "weblb1"
  load_balancer_type = "application"
  security_groups    = [var.albsg]
  subnets            = var.pub_sub
}
# Target group
resource "aws_lb_target_group" "tg1" {
  name     = "lb-tg1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
## Listener for load balancer
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.weblb1.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}
output "tgarn" {
  value = aws_lb_target_group.tg1.arn
}

