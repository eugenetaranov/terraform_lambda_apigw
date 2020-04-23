output "api_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com"
}

output "api_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
}