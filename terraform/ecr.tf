resource "aws_ecr_repository" "circleci-ecs-sample-nginx" {
  name                 = "circleci-ecs-sample-nginx"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}