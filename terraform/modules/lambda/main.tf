resource "aws_iam_role" "lambda_role" {
  name               = var.events_function_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.events_function_name}_policy"
  description = "IAM policy for Lambda function"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = [
          var.dynamodb_events_table_arn,
          var.dynamodb_users_table_arn
        ]
      },
      {
        Action   = "logs:*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_lambda_function" "events_lambda" {
  function_name = var.events_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.events_handler
  runtime       = var.runtime
  filename         = var.events_source_code_path
  source_code_hash = filebase64sha256(var.events_source_code_path)

  environment {
    variables = var.environment_variables
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment]
}

resource "aws_lambda_function" "users_lambda" {
  function_name = var.users_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.users_handler
  runtime       = var.runtime
  filename         = var.users_source_code_path
  source_code_hash = filebase64sha256(var.users_source_code_path)

  environment {
    variables = var.environment_variables
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_policy_attachment]
}