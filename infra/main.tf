resource "aws_iam_role" "apprunner_service_role" {
  name = "apprunner-2029-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "apprunner_policy" {
  name        = "apprunner-2029-policy"
  description = "Policy for AWS App Runner Service"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "ecr:GetAuthorizationToken",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.apprunner_service_role.name
  policy_arn = aws_iam_policy.apprunner_policy.arn
}

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
