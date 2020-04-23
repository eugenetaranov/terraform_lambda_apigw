variable "glue_database_name" {
  description = "AWS Glue database name"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket to crawl"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket arn to crawl"
  type        = string
}

variable "glue_crawler_name" {
  description = "AWS Glue crawler name"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = null
}

variable "iam_role_arn" {
  description = "Custom IAM role for glue crawler"
  type = string
  default = ""
}