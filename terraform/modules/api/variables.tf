variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "The description of the API Gateway"
  type        = string
}

variable "events_lambda_arn" {
  description = "The ARN of the Events Lambda function"
  type        = string
}

variable "users_lambda_arn" {
  description = "The ARN of the Users Lambda function"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
}