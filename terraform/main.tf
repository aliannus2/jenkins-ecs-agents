resource "aws_ecs_cluster" "project_jenkins_agents" {
  name = "project-jenkins-agents"
  tags = var.common_tags
}

resource "aws_ecr_repository" "ecs-terraform-agent" {
  name                 = "ecs-terraform-agent"
  image_tag_mutability = "MUTABLE"
  tags                 = var.common_tags
}

resource "aws_ecr_lifecycle_policy" "ecs_terraform_agent_untagged" {
  repository = aws_ecr_repository.ecs-terraform-agent.name
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images after 7 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 7
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name              = "/ecs/terraform-agent"
  retention_in_days = 7
  tags              = var.common_tags
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = data.aws_vpc.project-devops.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "project"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "project"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "project"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.common_tags
}

resource "aws_ecs_task_definition" "terraform_agent_task" {
  family                   = "terraform-agent-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_jenkins_agent_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_jenkins_agent_task_role.arn
  cpu                      = "1024"
  memory                   = "2048"
  container_definitions    = file("task-definitions/aws-terraform.json")
  tags                     = var.common_tags
}
