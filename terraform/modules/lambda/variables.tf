variable "events_function_name" {
  description = "The name of the Events lambda function"
  type        = string
}

variable "users_function_name" {
  description = "The name of the Users lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "environment_variables" {
  description = "A map of environment variables for the Lambda functions"
  type        = map(string)
  default     = {}
}

variable "memory_size" {
  description = "The amount of memory available to the function"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The function execution time at which Lambda should terminate the function"
  type        = number
  default     = 3
}

variable "events_source_code_path" {
  description = "The path to the source code for the Events Lambda function"
  type        = string
}

variable "users_source_code_path" {
  description = "The path to the source code for the Users Lambda function"
  type        = string
}

variable "dynamodb_events_table_arn" {
  description = "The ARN of the DynamoDB events table"
  type        = string
}

variable "dynamodb_users_table_arn" {
  description = "The ARN of the DynamoDB users table"
  type        = string
}