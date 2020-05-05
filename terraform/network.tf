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

# Internet Gateway
resource "aws_internet_gateway" "ecs-gateway" {
  vpc_id = aws_vpc.circleci-ecs-sample.id
  tags = {
    Name = "CircleCI ECS Sample Internet Gateway created by terraform"
  }
}

# Route Tables
resource "aws_route_table" "ecs-route-table" {
  vpc_id = aws_vpc.circleci-ecs-sample.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-gateway.id
  }
  tags = {
    Name = "CircleCI ECS Sample Route Table created by terraform"
  }
}

# Route Table Associations
resource "aws_route_table_association" "ecs-route-association-1a" {
  subnet_id      = aws_subnet.ecs-service-1a.id
  route_table_id = aws_route_table.ecs-route-table.id
}

resource "aws_route_table_association" "ecs-route-association-1c" {
  subnet_id      = aws_subnet.ecs-service-1c.id
  route_table_id = aws_route_table.ecs-route-table.id
}
