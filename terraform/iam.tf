resource "aws_iam_role" "ecs_jenkins_agent_task_role" {
  name = "ecs-jenkins-agent-task-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.common_tags
}

resource "aws_iam_policy" "ecs_jenkins_agent_task_policy" {
  name        = "ecs-jenkins-agent-task-policy"
  description = "Policy to allow ECS task to create and manage S3 buckets and DynamoDB tables"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "ssm:StartSession",
        "ssm:DescribeSessions",
        "ssm:GetSessionToken",
        "ssm:TerminateSession",
        "ssmmessages:*",
        "ecs:executeCommand",
        "ecs:DescribeTasks",
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::570730370608:role/project-core-jenkins-pipeline"
    }
  ]
}
EOF

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment" {
  role       = aws_iam_role.ecs_jenkins_agent_task_role.name
  policy_arn = aws_iam_policy.ecs_jenkins_agent_task_policy.arn
}

resource "aws_iam_role" "ecs_jenkins_agent_execution_role" {
  name = "ecs-jenkins-agent-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.common_tags
}

resource "aws_iam_policy" "ecs_jenkins_agent_execution_policy" {
  name        = "ecs-jenkins-agent-execution-policy"
  description = "Policy to allow ECS task execution to pull images and write logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  tags = var.common_tags
}

resource "aws_iam_policy" "ecs_task_logging_policy" {
  name        = "ecs-task-logging-policy"
  description = "Policy to allow ECS tasks to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "arn:aws:logs:*:*:log-group:/ecs/terraform-agent:*"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_logging_attachment" {
  role       = aws_iam_role.ecs_jenkins_agent_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_logging_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachment" {
  role       = aws_iam_role.ecs_jenkins_agent_execution_role.name
  policy_arn = aws_iam_policy.ecs_jenkins_agent_execution_policy.arn
}
