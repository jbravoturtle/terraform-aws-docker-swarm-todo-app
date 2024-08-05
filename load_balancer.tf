# Application Load Balancer
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.swarm_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "web-lb"
  }
}

# Target Group for Swarm Nodes
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 45
    timeout             = 30
    healthy_threshold   = 3
    unhealthy_threshold = 4
  }

  tags = {
    Name = "web-tg"
  }
}

# Create Listener for ALB
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

  depends_on = [aws_lb_target_group.web_tg]
}
