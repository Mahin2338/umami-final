output "alb_dns_name" {
    value = aws_lb.app1.dns_name
  
}

output "ecs_cluster_name" {
    value = module.ecs.cluster_name
}

output "ecs_service_name" {
    value = module.ecs.service_name
}

