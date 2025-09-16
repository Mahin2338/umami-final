variable "aws_region" {
  type = string

}

variable "aws_profile" {
  type    = string
  default = null

}

variable "vpc_cidr_block" {
  type = string

}

variable "public_subnet_a_cidr" {
  type = string

}

variable "public_subnet_b_cidr" {
  type = string

}

variable "private_subnet_a_cidr" {
  type = string

}

variable "private_subnet_b_cidr" {
  type = string

}

variable "az_a" {
  type = string

}

variable "az_b" {
  type = string

}

variable "app_port" {
  type    = number


}

variable "db_name" {
  type = string

}

variable "db_username" {
  type = string

}

variable "db_password" {
  type = string

}



variable "domain_name" { 
  type = string
  
}



variable "app_secret" {
  type = string
  sensitive = true
  
}

