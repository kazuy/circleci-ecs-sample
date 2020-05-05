terraform {
  backend "s3" {
    bucket  = "kazuy-circleci-ecs-sample-terraform"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
