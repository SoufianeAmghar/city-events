provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

module "api_gateway" {
  source            = "../../modules/api"
  api_name          = "CityEventsAPI"
  api_description   = "API Gateway for City Events"
  events_lambda_arn = module.lambda.events_lambda_arn
  users_lambda_arn  = module.lambda.users_lambda_arn
  region            = var.region
  account_id        = data.aws_caller_identity.current.account_id
}

module "lambda" {
  source                    = "../../modules/lambda"
  events_source_code_path   = "../../lambda/events_lambda.zip"
  users_source_code_path    = "../../lambda/users_lambda.zip"
  events_function_name      = var.events_lambda_function_name
  users_function_name       = var.users_lambda_function_name
  events_handler            = var.events_lambda_handler
  users_handler             = var.users_lambda_handler
  runtime                   = var.lambda_runtime
  dynamodb_events_table_arn = module.dynamodb.dynamodb_events_table_arn
  dynamodb_users_table_arn  = module.dynamodb.dynamodb_users_table_arn
  environment_variables = {
    EVENTS_TABLE_NAME = var.dynamodb_events_table_name
    USERS_TABLE_NAME  = var.dynamodb_users_table_name
    MEDIA_BUCKET_NAME = var.s3_bucket_name
  }
}

module "dynamodb" {
  source                = "../../modules/db"
  events_table_name     = var.dynamodb_events_table_name
  users_table_name      = var.dynamodb_users_table_name
  read_capacity         = var.dynamodb_read_capacity
  write_capacity        = var.dynamodb_write_capacity
  attribute_definitions = var.dynamodb_attribute_definitions
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = var.s3_bucket_name
  versioning  = var.s3_versioning
}
