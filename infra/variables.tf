variable "service_name" {
  description = "The name of the AWS App Runner service"
  type        = string
  default     = "candidate-2029-apprunner"
}

variable "image_identifier" {
  description = "ECR image identifier for AWS App Runner service"
  type        = string
  default     = "244530008913.dkr.ecr.eu-west-1.amazonaws.com/2029-repository:latest"
}

variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
  default     = "eu-west-1"
}

variable "notification_email" {
  type        = string
  description = "Email address to receive notifications"
  default     = "tenico05@gmail.com"
}
