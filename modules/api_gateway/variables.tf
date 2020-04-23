variable "api_name" {
  description = "API name"
  type        = string
}

variable "api_description" {
  description = "API description"
  type        = string
  default     = ""
}

variable "lambda_authorizer_arn" {
  description = "API authorizer lambda function ARN"
  type        = string
  default     = ""
}

variable "lambda_authorizer_invoke_arn" {
  description = "API authorizer lambda function invoke ARN"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = null
}

variable "api_endpoint_type" {
  description = "API endpoint type"
  type        = string
}

variable "api_authorizer_type_identity_source" {
  description = "API authorizer identity source"
  type        = string
  default     = ""
}

variable "lambda_request_handler_arn" {
  description = "Lambda request handler ARN"
  type        = string
}

variable "lambda_request_handler_invoke_arn" {
  description = "Lambda request handler invoke ARN"
  type        = string
}
