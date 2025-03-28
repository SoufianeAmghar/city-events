output "dynamodb_events_table_name" {
  value = aws_dynamodb_table.events.name
}

output "dynamodb_events_table_arn" {
  value = aws_dynamodb_table.events.arn
}

output "dynamodb_users_table_name" {
  value = aws_dynamodb_table.users.name
}

output "dynamodb_users_table_arn" {
  value = aws_dynamodb_table.users.arn
}