resource "aws_s3_bucket" "terraform_state" {
  bucket = "kazuy-circleci-ecs-sample-terraform"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "ecs-lb-logs" {
  bucket = "kazuy-circleci-ecs-sample"
}

resource "aws_s3_bucket_policy" "ecs-lb-logs" {
  bucket = aws_s3_bucket.ecs-lb-logs.id

  policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::582318560864:root"
          },
          "Action": "s3:PutObject",
          "Resource": "arn:aws:s3:::${aws_s3_bucket.ecs-lb-logs.bucket}/ecs-elb-logs/*"
        }
      ]
    }
  POLICY
}
