# Create Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "my-generated-key"
  public_key = file("~/.ssh/my-key-pair.pub")
}

# Launch Configuration for Swarm Nodes
resource "aws_launch_configuration" "swarm_lc" {
  image_id                    = "ami-0427090fd1714168b"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.swarm_sg.id]
  key_name                    = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/scripts/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.web_lb]
}

# Auto Scaling Group for Swarm Nodes
resource "aws_autoscaling_group" "swarm_asg" {
  vpc_zone_identifier  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  launch_configuration = aws_launch_configuration.swarm_lc.name
  min_size             = 4
  max_size             = 6
  desired_capacity     = 4

  tag {
    key                 = "Name"
    value               = "swarm-node"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb_listener.web_listener]
}

# Attach Auto Scaling Group to Load Balancer Target Group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.swarm_asg.id
  lb_target_group_arn   = aws_lb_target_group.web_tg.arn
}

# Capture instance IDs for swarm nodes in the ASG
data "aws_instances" "swarm_instances" {
  instance_tags = {
    Name = "swarm-node"
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [aws_autoscaling_group.swarm_asg]
}
