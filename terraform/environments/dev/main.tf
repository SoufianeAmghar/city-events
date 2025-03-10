provider "aws" {
  region = "us-east-1"
}

module "api_gateway" {
  source          = "../../modules/apigateway"
  api_name        = "CityEventsAPI"
  api_description = "API Gateway for City Events"
  events_lambda_arn   = module.lambda.events_lambda_arn
  users_lambda_arn    = module.lambda.users_lambda_arn
}

module "lambda" {
  source             = "../../modules/lambda"
  events_source_code_path = "https://github.com/SoufianeAmghar/city-events/blob/main/lambda/events.txt"
  users_source_code_path  = "https://github.com/SoufianeAmghar/city-events/blob/main/lambda/users.txt"
  events_function_name    = var.events_lambda_function_name
  users_function_name     = var.users_lambda_function_name
  handler                 = var.lambda_handler
  runtime                 = var.lambda_runtime
  dynamodb_events_table_arn      = module.dynamodb.dynamodb_events_table_arn
  dynamodb_users_table_arn      = module.dynamodb.dynamodb_users_table_arn
}

module "dynamodb" {
  source                = "../../modules/dynamodb"
  events_table_name     = var.dynamodb_events_table_name
  users_table_name      = var.dynamodb_users_table_name
  attribute_definitions = var.dynamodb_attribute_definitions
  read_capacity         = var.dynamodb_read_capacity
  write_capacity        = var.dynamodb_write_capacity

}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.s3_bucket_name
  versioning  = var.s3_versioning
}