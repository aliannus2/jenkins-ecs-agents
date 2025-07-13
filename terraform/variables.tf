variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "aws_region" {
  description = "AWS region for provider"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile for provider"
  type        = string
  default     = "project-devops"
}

