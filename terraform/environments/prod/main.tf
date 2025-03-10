resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("var.lambda_zip_file")

  environment {
    variables = "var.environment_variables"
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy" {
  name       = "${var.lambda_function_name}_policy_attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "dynamodb" {
  source = "../../modules/dynamodb"
  events_table_name = var.dynamodb_events_table_name
  users_table_name = var.dynamodb_users_table_name
  attribute_definitions = var.dynamodb_attribute_definitions
  read_capacity = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = var.s3_bucket_name
  versioning   = var.s3_versioning
}

output "lambda_function_arn" {
  value = aws_lambda_function.my_lambda.arn
}

output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}