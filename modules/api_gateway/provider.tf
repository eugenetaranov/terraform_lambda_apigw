provider "aws" {
  version = "~> 2.58"
  region  = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}