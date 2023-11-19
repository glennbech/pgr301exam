resource "aws_apprunner_service" "apprunner_service" {
  service_name = var.service_name

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_service_role.arn
    cpu               = 256
    memory            = 1024
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_service_role.arn
    }
    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = var.image_identifier
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
  }
}

resource "aws_iam_role" "apprunner_service_role" {
  name               = "FunnyUniqueAppRunnerServiceRole"
  assume_role_policy = data.aws_iam_policy_document.apprunner_assume_role.json
}

data "aws_iam_policy_document" "apprunner_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["tasks.apprunner.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "apprunner_policy" {
  statement {
    effect    = "Allow"
    actions   = ["rekognition:*"]
    resources = ["*"]
  }
  
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "apprunner_policy" {
  name        = "FunnyUniqueAppRunnerPolicy"
  description = "Policy for AWS App Runner service instance"
  policy      = data.aws_iam_policy_document.apprunner_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.apprunner_service_role.name
  policy_arn = aws_iam_policy.apprunner_policy.arn
}
