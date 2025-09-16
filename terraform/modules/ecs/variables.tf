variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "container_image" {
  default = "165258187464.dkr.ecr.eu-west-2.amazonaws.com/umami:v1"
}

variable "container_port" {
  description = "App container port"
  type        = number
  
}

variable "task_cpu" {
  description = "Fargate task CPU units (e.g., 256, 512, 1024)"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Fargate task memory in MiB (e.g., 512, 1024, 2048)"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "How many tasks to run"
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the ECS service"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for the service"
  type        = string
}

# Database connection (from RDS module)
variable "db_host" {
  description = "RDS hostname"
  type        = string
}

variable "db_port" {
  description = "RDS port"
  type        = number
  default     = 5432
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "DB username"
  type        = string
}

variable "db_password" {
  description = "DB password"
  type        = string
  sensitive   = true
}



variable "app_url" {
  type = string
  
}


  

variable "app_secret" {
  type = string
  sensitive = true
  
}
variable "alb_dns_name" {
  type = string
}