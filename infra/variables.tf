variable "service_name" {
  description = "The name of the AWS App Runner service"
  type        = string
  default     = "candidate-2029"
}

variable "image_identifier" {
  description = "ECR image identifier for AWS App Runner service"
  type        = string
  default     = "244530008913.dkr.ecr.eu-west-1.amazonaws.com/2029-repository:latest"
}
