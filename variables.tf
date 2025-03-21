variable "project" {
}

variable "environment" {
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "public_cidr" {
    validation {
        condition = length(var.public_cidr) == 2
        error_message = "must give 2 public subnets"
    }
}

variable "private_cidr" {
 validation {
        condition = length(var.private_cidr) == 2
        error_message = "must give 2 private subnets"
    }
}


variable "database_cidr" {
 validation {
        condition = length(var.database_cidr) == 2 
        error_message = "must give 2 database subnets"
    }
}
