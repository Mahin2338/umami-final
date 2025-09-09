terraform {
  backend "s3" {
    bucket  = "ecs-umami-terraform-state"
    key     = "ecs-final-project/terraform.tfstate"
    region  = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt = true
    
  }
}