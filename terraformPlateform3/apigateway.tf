resource "aws_apigatewayv2_api" "main" {
  name = "main"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = [ "*" ]
    allow_headers = [ "*" ]
    allow_methods = [ "GET", "POST" ]
  }
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.main.id
  name = "dev"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_hello" {
  api_id = aws_apigatewayv2_api.main.id
  integration_uri = aws_lambda_function.hello.invoke_arn
  integration_type = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "get_hello" {
  api_id = aws_apigatewayv2_api.main.id
  route_key = "GET /hello"
  target = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

resource "aws_apigatewayv2_route" "post_hello" {
  api_id = aws_apigatewayv2_api.main.id
  route_key = "POST /hello"
  target = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

output "hello_base_url" {
  value = aws_apigatewayv2_stage.dev.invoke_url
}