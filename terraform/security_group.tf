resource "aws_security_group" "ecs-service" {
  name        = "ecs-service-security-group"
  description = "CircleCI ECS Sample Security Group"
  vpc_id      = aws_vpc.circleci-ecs-sample.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "CircleCI ECS Sample Security Group created by terraform"
  }
}