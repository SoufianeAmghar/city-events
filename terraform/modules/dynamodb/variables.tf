variable "events_table_name" {
  description = "The name of the DynamoDB events table"
  type        = string
}

variable "users_table_name" {
  description = "The name of the DynamoDB users table"
  type        = string
}

variable "attribute_definitions" {
  description = "The attribute definitions for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
}

variable "read_capacity" {
  description = "The read capacity units for the DynamoDB table"
  type        = number
}

variable "write_capacity" {
  description = "The write capacity units for the DynamoDB table"
  type        = number
}