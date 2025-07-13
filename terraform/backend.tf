terraform {
  backend "s3" {
    bucket         = "project-devops-us-east-1-terraform-states"
    key            = "us-east-1/ecs/project-jenkins-agents/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "project-devops-terraform.lock"
    encrypt        = true
  }
}
