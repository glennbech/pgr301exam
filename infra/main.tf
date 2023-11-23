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

resource "aws_apprunner_service" "service" {
  service_name = var.service_name

  instance_configuration {
    instance_role_arn = "arn:aws:iam::244530008913:role/service-role/AppRunnerECRAccessRole"
    cpu               = 256
    memory            = 1024
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::244530008913:role/service-role/AppRunnerECRAccessRole"
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
