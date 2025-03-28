output "events_lambda_function_arn" {
  value = module.lambda.events_lambda_arn
}

output "dynamodb_events_table_name" {
  value = module.dynamodb.dynamodb_events_table_name
}

output "dynamodb_events_table_arn" {
  value = module.dynamodb.dynamodb_events_table_arn
}

output "users_lambda_function_arn" {
  value = module.lambda.users_lambda_arn
}

output "dynamodb_users_table_name" {
  value = module.dynamodb.dynamodb_users_table_name
}

output "dynamodb_users_table_arn" {
  value = module.dynamodb.dynamodb_users_table_arn
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "api_endpoint_url" {
  value = module.api_gateway.api_endpoint
}