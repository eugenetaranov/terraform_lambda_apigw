variable "aws_region" {
  default = "us-east-1"
}

variable "az" {
  default = ["a", "b", "c"]
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
}