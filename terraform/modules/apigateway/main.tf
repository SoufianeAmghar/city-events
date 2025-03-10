resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_description
}

# Users Resource
resource "aws_api_gateway_resource" "users_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

# Users/Create User Endpoint
resource "aws_api_gateway_resource" "create_user" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.users_resource.id
  path_part   = "create-user"
}

resource "aws_api_gateway_method" "create_user_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.create_user.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_user_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.create_user.id
  http_method             = aws_api_gateway_method.create_user_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.users_lambda_arn
}

# Events Resource
resource "aws_api_gateway_resource" "events_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "events"
}

# Events/Create Event Endpoint
resource "aws_api_gateway_resource" "create_event" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.events_resource.id
  path_part   = "create-event"
}

resource "aws_api_gateway_method" "create_event_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.create_event.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "create_event_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.create_event.id
  http_method             = aws_api_gateway_method.create_event_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.events_lambda_arn
}

# Events/Find Event Endpoint
resource "aws_api_gateway_resource" "find_event" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.events_resource.id
  path_part   = "find-event"
}

resource "aws_api_gateway_method" "find_event_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.find_event.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "find_event_post" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.find_event.id
  http_method             = aws_api_gateway_method.find_event_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.events_lambda_arn
}

# Lambda Permissions
resource "aws_lambda_permission" "api_gateway_users" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.users_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_events" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.events_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_endpoint" {
  value = aws_api_gateway_rest_api.api.execution_arn
}