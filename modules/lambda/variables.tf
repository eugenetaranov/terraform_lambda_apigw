variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = null
}

variable "function_runtime" {
  description = "Lambda function runtime."
  type        = string
}

variable "function_memory" {
  description = "Lambda function memory limit"
  type        = number
}

variable "function_handler" {
  description = "Lambda function entrypoint"
  type        = string
}

variable "function_timeout" {
  description = "Lambda function timeout"
  type        = number
}

variable "function_environment" {
  description = "Lambda function environment variables"
  type = object({
    variables = map(string)
  })
  default = null
}

variable "function_source_file" {
  description = "Lambda function source"
  type        = string
}

variable "function_description" {
  description = "Lambda function description"
  type        = string
}

variable "function_iam_role" {
  description = "Lambda function IAM role ARN"
  type        = string
  default     = ""
}

variable "log_retention_perion" {
  description = "Cloudwatch logs retention period, days"
  type        = number
}

variable "request_handler_api_gw_arn" {
  description = "ARN of the API GW to integrate with"
  type = string
  default = ""
}