output "ecs_cluster_id" {
  value = aws_ecs_cluster.project_jenkins_agents.id
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.terraform_agent_task.arn
}

output "ecs_service_sg" {
  value = aws_security_group.ecs_service_sg.id
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_jenkins_agent_task_role.arn
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_jenkins_agent_execution_role.arn
}