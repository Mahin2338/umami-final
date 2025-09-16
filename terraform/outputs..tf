output "alb_dns_name" {
    value = aws_lb.app1.dns_name
  
}

output "ecs_cluster_name" {
    value = module.ecs.cluster_name
}

output "ecs_service_name" {
    value = module.ecs.service_name
}

output "route53_zone_id" {
    value = aws_route53_zone.primary.zone_id
  
}

output "db_host" { 
    value = module.rds.db_host
  
}