locals {
  resource_name = "${var.function_name}-lambda"
}

resource "aws_iam_role" "lambda_role" {
  count              = var.function_iam_role == "" ? 1 : 0
  name               = local.resource_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role[0].json
  tags               = var.tags
}

data "aws_iam_policy_document" "lambda_assume_role" {
  count = var.function_iam_role == "" ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  count  = var.function_iam_role == "" ? 1 : 0
  name   = local.resource_name
  role   = aws_iam_role.lambda_role[0].id
  policy = data.aws_iam_policy_document.lambda_role[0].json
}

data "aws_iam_policy_document" "lambda_role" {
  count = var.function_iam_role == "" ? 1 : 0

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_perion
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${substr(path.root, length(path.cwd), -1)}${var.function_source_file}"
  output_path = "${substr(path.root, length(path.cwd), -1)}${var.function_source_file}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = "${substr(path.root, length(path.cwd), -1)}${var.function_source_file}.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  role             = var.function_iam_role == "" ? aws_iam_role.lambda_role[0].arn : var.function_iam_role
  handler          = var.function_handler
  description      = var.function_description
  memory_size      = var.function_memory
  timeout          = var.function_timeout
  runtime          = var.function_runtime

  dynamic "environment" {
    for_each = var.function_environment == null ? [] : [var.function_environment]
    content {
      variables = environment.value.variables
    }
  }

  tags = var.tags
}
