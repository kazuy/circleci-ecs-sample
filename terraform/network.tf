# VPC
resource "aws_vpc" "circleci-ecs-sample" {
  cidr_block = "12.0.0.0/16"
  tags = {
    Name = "CircleCI ECS Sample VPC created by terraform"
  }
}

# Subnets
resource "aws_subnet" "ecs-service-1a" {
  vpc_id            = aws_vpc.circleci-ecs-sample.id
  cidr_block        = "12.0.11.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "CircleCI ECS Sample Subnet 1a created by terraform"
  }
}

resource "aws_subnet" "ecs-service-1c" {
  vpc_id            = aws_vpc.circleci-ecs-sample.id
  cidr_block        = "12.0.12.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "CircleCI ECS Sample Subnet 1c created by terraform"
  }
}