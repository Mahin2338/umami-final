variable "vpc_cidr_block" {
  
  type        = string
  
  
}

variable "public_subnet_a_cidr" {
  
  type        = string
  
}

variable "public_subnet_b_cidr" {
  
  type        = string
  
}

variable "private_subnet_a_cidr" {
  
  type        = string
  
}

variable "private_subnet_b_cidr" {

  type        = string
  
}

variable "az_a" {
  
  type        = string
  
}

variable "az_b" {
  description = "Availability Zone for subnet set B"
  type        = string
  
}