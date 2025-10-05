terraform {
  backend "s3" {
    bucket         = "ecs-umami-terraform-state-new"
    key            = "ecs-final-project/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks-new"
    encrypt        = true
  }
}