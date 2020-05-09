# Cluster
resource "aws_ecs_cluster" "circleci-ecs-cluster" {
  name = "circleci-ecs-sample-cluster"
  tags = {
    Name = "CircleCI ECS Sample Cluster created by terraform"
  }
}

# Simply specify the family to find the latest ACTIVE revision in that family.
data "aws_ecs_task_definition" "circleci-ecs-task" {
  task_definition = "${aws_ecs_task_definition.circleci-ecs-task.family}"
}

# Task definition
resource "aws_ecs_task_definition" "circleci-ecs-task" {
  family                   = "circleci-ecs-sample-task"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  container_definitions    = <<-EOL
    [
      {
        "name": "nginx",
        "image": "${aws_ecr_repository.circleci-ecs-sample-nginx.repository_url}:latest",
        "essential": true,
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 80
          }
        ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/circleci-ecs-sample-task",
            "awslogs-region": "ap-northeast-1",
            "awslogs-stream-prefix": "ecs"
          }
        }
      }
    ]
  EOL
}

# Service
resource "aws_ecs_service" "circleci-ecs-service" {
  name            = "circleci-ecs-sample-service"
  cluster         = aws_ecs_cluster.circleci-ecs-cluster.id
  task_definition = "${aws_ecs_task_definition.circleci-ecs-task.family}:${max("${aws_ecs_task_definition.circleci-ecs-task.revision}", "${data.aws_ecs_task_definition.circleci-ecs-task.revision}")}" # Track the latest ACTIVE revision
  desired_count   = 0
  launch_type     = "FARGATE"
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-service-tg.arn
    container_name   = "nginx"
    container_port   = 80
  }
  network_configuration {
    subnets          = [aws_subnet.ecs-service-1a.id, aws_subnet.ecs-service-1c.id]
    security_groups  = [aws_security_group.ecs-service.id]
    assign_public_ip = true
  }
}