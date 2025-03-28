output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "api_endpoint" {
  value = aws_api_gateway_stage.stage.invoke_url
}