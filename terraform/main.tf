terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  app_port = var.app_port
}



# ── VPC ────────────────────────────────────────────────────────────────────────
module "vpc" {
  source                = "./modules/vpc"
  vpc_cidr_block        = var.vpc_cidr_block
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  az_a                  = var.az_a
  az_b                  = var.az_b
}

# ── Security Groups ───────────────────────────────────────────────────────────
module "security" {
  source             = "./modules/security"
  vpc_id             = module.vpc.vpc_id
  app_port           = var.app_port
  rds_port           = 5432
  allowed_http_cidr  = ["0.0.0.0/0"]
  allowed_https_cidr = ["0.0.0.0/0"]
}

# ── RDS (PostgreSQL) ─────────────────────────────────────────────────────────
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id 
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id 
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

# ── ECR Repo ─────────────────────────────────────────────────────────────────
resource "aws_ecr_repository" "umami" {
  name                 = "umami"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
  tags = { Name = "umami-ecr" }
}

# ── ALB + TG + Listener ──────────────────────────────────────────────────────
resource "aws_lb" "app1" {
  name               = "pastefy-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [module.security.alb_sg_id]
  subnets            = module.vpc.public_subnet_ids
  tags               = { Name = "outline-alb" }
}

resource "aws_lb_target_group" "app" {
  name        = "umami-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    matcher             = "200-399"
    
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = { Name = "umami-tg" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app1.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn

   
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.app1.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:eu-west-2:165258187464:certificate/ac79a385-de32-4f93-940e-a1d811b4a246"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_route53_zone" "primary" {
  name = var.domain_name
}


resource "aws_route53_record" "root_a" {
  zone_id = aws_route53_zone.primary.zone_id
  name = var.domain_name
  type = "A"
  
  alias {
    name = aws_lb.app1.dns_name
    zone_id = aws_lb.app1.zone_id
    evaluate_target_health = true

  }
}






# ── ECS (Fargate) ────────────────────────────────────────────────────────────
module "ecs" {
  source = "./modules/ecs" # <-- was /modules/ecs; must be relative from root

  aws_region   = var.aws_region
  cluster_name = "pastefy-cluster"

  # For smoke test use nginx. Be sure app_port=80 in tfvars while testing.
  container_image = "${aws_ecr_repository.umami.repository_url}:v1"
  container_port  = local.app_port

  private_subnet_ids = module.vpc.private_subnet_ids
  ecs_sg_id          = module.security.ecs_sg_id
  target_group_arn   = aws_lb_target_group.app.arn

  # DB inputs (module likely requires ALL of these)
  db_host     = module.rds.address
  db_port     = 5432
  db_name     = var.db_name
  db_username = var.db_username # <-- add username (was missing)
  db_password = var.db_password
  app_secret = var.app_secret


  app_url      = "http://${var.domain_name}"
  
}


