resource "aws_lb" "myLB" {
  name                       = "my-load-balancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = ["sg-0eab5703bd414ff4a"]
  subnets                    = ["subnet-0f080ef2f97c4938e", "subnet-09f7bc1b7fdf84943", "subnet-05bbc4ce3965a1197"]
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.myLB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }
}
