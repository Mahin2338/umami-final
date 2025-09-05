variable "vpc_id" {
  
  type        = string
}

variable "app_port" {
  
  type        = number
  
  
}

variable "rds_port" {
  type        = number
  default     = 3306
  
}



variable "allowed_http_cidr" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  
}

variable "allowed_https_cidr" {
  
  type        = list(string)
  default     = ["0.0.0.0/0"]
  
}