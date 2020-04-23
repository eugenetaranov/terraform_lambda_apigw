resource "aws_glue_crawler" "main" {
  database_name = var.glue_database_name
  name          = "main"
  role          = var.iam_role_arn == "" ? aws_iam_role.glue_crawler[0].arn : var.iam_role_arn

  s3_target {
    path = "s3://${var.s3_bucket}"
  }
}

resource "aws_iam_role" "glue_crawler" {
  count              = var.iam_role_arn == "" ? 1 : 0
  name               = "glue_crawler_${var.glue_crawler_name}"
  assume_role_policy = data.aws_iam_policy_document.glue_crawler_assume_role[0].json
  tags               = var.tags
}

data "aws_iam_policy_document" "glue_crawler_assume_role" {
  count = var.iam_role_arn == "" ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "glue_crawler" {
  count  = var.iam_role_arn == "" ? 1 : 0
  name   = "glue_crawler_${var.glue_crawler_name}"
  role   = aws_iam_role.glue_crawler[0].id
  policy = data.aws_iam_policy_document.glue_crawler_role[0].json
}

data "aws_iam_policy_document" "glue_crawler_role" {
  count = var.iam_role_arn == "" ? 1 : 0

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = ["${var.s3_bucket_arn}*"]
  }
}

resource "aws_iam_role_policy_attachment" "glue_crawler" {
  count      = var.iam_role_arn == "" ? 1 : 0
  role       = aws_iam_role.glue_crawler[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}