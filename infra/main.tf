data "aws_iam_role" "apprunner_service_role" {
  name = "apprunner-2029-role"
}

data "aws_iam_policy" "apprunner_policy" {
  name = "apprunner-2029-policy"
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = data.aws_iam_role.apprunner_service_role.name
  policy_arn = data.aws_iam_policy.apprunner_policy.arn
}

resource "aws_apprunner_service" "apprunner_service" {
  service_name = var.service_name

  instance_configuration {
    instance_role_arn = data.aws_iam_role.apprunner_service_role.arn
    cpu               = 256
    memory            = 1024
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = data.aws_iam_role.apprunner_service_role.arn
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
