resource "aws_dynamodb_table" "events" {
  name           = var.events_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  hash_key  = "id"
  range_key = "timestamp"

  tags = {
    Name = var.events_table_name
  }
}

resource "aws_dynamodb_table" "users" {
  name           = var.users_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  hash_key  = "user_id"
  range_key = "email"

  tags = {
    Name = var.users_table_name
  }
}