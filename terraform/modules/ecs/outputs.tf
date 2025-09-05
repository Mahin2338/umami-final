output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "ECS service ARN"
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "ECS task definition ARN"
  value       = aws_ecs_task_definition.app.arn
}

output "log_group_name" {
  description = "CloudWatch log group used by the container"
  value       = aws_cloudwatch_log_group.app.name
}

output "container_port" {
  description = "Container/app port exposed by the service"
  value       = var.container_port
}