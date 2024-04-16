// *******************************************************
resource "aws_lb_target_group" "mytg" {
  name                 = "mytargetgp"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "vpc-0bb36347b849ade49"
  deregistration_delay = "100"
  ip_address_type      = "ipv4"

  health_check {
    path                = "/"
    interval            = 10
    timeout             = 7
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-499"
  }
}

# resource "aws_lb_target_group_attachment" "ec2_targets" {
#   count            = 2 # Number of EC2 instances to register
#   target_group_arn = aws_lb_target_group.mytg.arn
#   target_id        = ["i-01f9f53ce17c979c5", "i-0d3e0fb8a23f78401"][count.index] # Use your EC2 instance IDs here
#   port             = 80
# }

//************************************* end of custom tg*/

# resource "aws_lb_target_group" "mytg" {
#   name        = "my-tg"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = "vpc-0bb36347b849ade49"  # Replace with your VPC ID
#   target_type = "instance"

#   health_check {
#     path                = "/"
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#   }
# }

