terraform {
  backend "s3" {
    bucket         = "2029-terraform-state-bucket"
    key            = "nime003/state/apprunner.state"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apprunner.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["rekognition:*", "s3:*", "cloudwatch:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "role_for_apprunner_service" {
  name               = "2029-crazy-cool-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "policy" {
  name        = "2029-crazy-cool-policy"
  description = "Policy for AWS App Runner Service"
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.role_for_apprunner_service.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_apprunner_service" "service" {
  service_name = var.service_name

  instance_configuration {
    instance_role_arn = aws_iam_role.role_for_apprunner_service.arn
    cpu               = 256
    memory            = 1024
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.role_for_apprunner_service.arn
    }
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = var.img
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
  }
}
