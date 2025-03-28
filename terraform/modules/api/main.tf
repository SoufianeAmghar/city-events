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
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.users_lambda_arn}/invocations"
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
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.events_lambda_arn}/invocations"
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
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.events_lambda_arn}/invocations"
}

# Lambda Permissions
resource "aws_lambda_permission" "api_gateway_users" {
  statement_id  = "AllowAPIGatewayInvokeUsers"
  action        = "lambda:InvokeFunction"
  function_name = var.users_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/dev/POST/users/create-user"
}

resource "aws_lambda_permission" "api_gateway_events" {
  statement_id  = "AllowAPIGatewayInvokeEvents"
  action        = "lambda:InvokeFunction"
  function_name = var.events_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/dev/POST/events/create-event"
}

# API Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(join(",", [
      aws_api_gateway_method.create_user_post.id,
      aws_api_gateway_method.create_event_post.id,
      aws_api_gateway_method.find_event_post.id
    ]))
  }

  depends_on = [
    aws_api_gateway_integration.create_user_post,
    aws_api_gateway_integration.create_event_post,
    aws_api_gateway_integration.find_event_post
  ]
}

# API Stage
resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"

  depends_on = [aws_api_gateway_deployment.deployment]
}
