resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_description

  endpoint_configuration {
    types = [var.api_endpoint_type]
  }
}

resource "aws_api_gateway_authorizer" "api" {
  count                  = var.api_authorizer_lambda == "" ? 0 : 1
  name                   = var.api_name
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = var.api_authorizer_lambda
  authorizer_credentials = aws_iam_role.authorizer[0].arn
  type                   = var.api_authorizer_type
  identity_source        = var.api_authorizer_type_identity_source
}

resource "aws_iam_role" "authorizer" {
  count              = var.api_authorizer_lambda == "" ? 0 : 1
  name               = "apigw-authorizer-role-${var.api_name}"
  assume_role_policy = data.aws_iam_policy_document.authorizer_assume_role[0].json
  tags               = var.tags
}

data "aws_iam_policy_document" "authorizer_assume_role" {
  count = var.api_authorizer_lambda == "" ? 0 : 1
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "authorizer_role_policy" {
  count  = var.api_authorizer_lambda == "" ? 0 : 1
  name   = "apigw-authorizer-rolepolicy-${var.api_name}"
  role   = aws_iam_role.authorizer[0].id
  policy = data.aws_iam_policy_document.authorizer_role[0].json
}

data "aws_iam_policy_document" "authorizer_role" {
  count = var.api_authorizer_lambda == "" ? 0 : 1
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      var.api_authorizer_lambda
    ]
  }
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

## Integration with lambda request handler
resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = var.api_authorizer_type
  authorizer_id = var.api_authorizer_lambda == "" ? "" : aws_api_gateway_authorizer.api[0].id
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_method.proxy.resource_id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_request_handler_invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "ANY"
  authorization = var.api_authorizer_type
  authorizer_id = var.api_authorizer_lambda == "" ? "" : aws_api_gateway_authorizer.api[0].id
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_method.proxy_root.resource_id
  http_method             = aws_api_gateway_method.proxy_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_request_handler_invoke_arn
}

resource "aws_api_gateway_deployment" "test" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "test"
}

resource "aws_lambda_permission" "api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_request_handler_arn
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}