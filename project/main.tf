provider "aws" {
  version = "~> 2.58"
  region  = var.aws_region
}

module "lambda_authorizer" {
  source               = "../modules/lambda"
  function_description = "lambda authrozier for APIGW"
  function_handler     = "authorizer.lambda_handler"
  function_memory      = 128
  function_name        = "lambda-authorizer"
  function_runtime     = "python3.8"
  function_source_file = "lambda_src/authorizer.py"
  function_timeout     = 30
  log_retention_perion = 1
}

module "lambda_root_get" {
  source               = "../modules/lambda"
  function_description = "lambda handler for APIGW"
  function_handler     = "handler.lambda_handler"
  function_memory      = 128
  function_name        = "lambda-handler"
  function_runtime     = "python3.8"
  function_source_file = "lambda_src/handler.py"
  function_timeout     = 30
  log_retention_perion = 1
}

module "apigw" {
  source                            = "../modules/api_gateway"
  api_name                          = "test"
  api_endpoint_type                 = "REGIONAL"
  lambda_request_handler_arn        = module.lambda_root_get.arn
  lambda_request_handler_invoke_arn = module.lambda_root_get.invoke_arn
  lambda_authorizer_arn             = module.lambda_authorizer.arn
  lambda_authorizer_invoke_arn      = module.lambda_authorizer.invoke_arn
}

output "api_gw_url" {
  value = module.apigw.api_url
}

output "api_arn" {
  value = module.apigw.api_arn
}
