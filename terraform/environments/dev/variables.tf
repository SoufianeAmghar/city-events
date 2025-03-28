variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "events_lambda_function_name" {
  description = "The name of the Events lambda function"
  type        = string
}

variable "users_lambda_function_name" {
  description = "The name of the Users lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.8"
}

variable "events_lambda_handler" {
  description = "The handler for the Events lambda function"
  type        = string
}

variable "users_lambda_handler" {
  description = "The handler for the Users lambda function"
  type        = string
}

variable "dynamodb_events_table_name" {
  description = "The name of the DynamoDB events table"
  type        = string
}

variable "dynamodb_users_table_name" {
  description = "The name of the DynamoDB users table"
  type        = string
}

variable "dynamodb_read_capacity" {
  description = "The read capacity units for the DynamoDB table"
  type        = number
  default     = 5
}

variable "dynamodb_write_capacity" {
  description = "The write capacity units for the DynamoDB table"
  type        = number
  default     = 5
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "s3_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "A map of environment variables for the Lambda functions"
  type        = map(string)
  default     = {}
}

variable "dynamodb_attribute_definitions" {
  description = "The attribute definitions for the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "timestamp"
      type = "N"
    }
  ]
}