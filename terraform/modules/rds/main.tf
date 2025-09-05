# Subnet group
resource "aws_db_subnet_group" "postgres" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = { Name = "rds-subnet-group" }
}


resource "aws_db_instance" "this" {
  identifier = "umami-db"
  engine = "postgres"
  engine_version = "15"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp3"
  port = 5432


  db_name = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  backup_retention_period = 1
  apply_immediately = true


  tags = {
    Name = "umami-postgres"
  }
  }


