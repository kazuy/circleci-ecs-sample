# Elastic Load Balancer
resource "aws_lb" "ecs-service-elb" {
  name               = "ecs-service-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs-service.id]
  subnets            = [aws_subnet.ecs-service-1a.id, aws_subnet.ecs-service-1c.id]

  access_logs {
    bucket  = aws_s3_bucket.ecs-lb-logs.bucket
    prefix  = "ecs-elb-logs"
    enabled = true
  }

  tags = {
    Name = "CircleCI ECS Sample Load Balancer created by terraform"
  }
}

# Target Group
resource "aws_lb_target_group" "ecs-service-tg" {
  name        = "ecs-service-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.circleci-ecs-sample.id

  tags = {
    Name = "CircleCI ECS Sample Target Group created by terraform"
  }
}

# Listener
resource "aws_lb_listener" "ecs-service-listener" {
  load_balancer_arn = aws_lb.ecs-service-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-service-tg.arn
  }
}
