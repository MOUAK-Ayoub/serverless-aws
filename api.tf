resource "aws_apigatewayv2_api" "api" {
  name          = "myapi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "dev"{
  api_id = aws_apigatewayv2_api.api.id
  name = "dev"
  auto_deploy = true

}

resource "aws_apigatewayv2_integration" "lambda_integration" {

  api_id = aws_apigatewayv2_api.api.id
  integration_method = "POST"
  integration_type   = "AWS_PROXY"
  integration_uri    = module.lambda_api.lambda_invoke_arn

}

resource "aws_apigatewayv2_route" "get_items" {

  api_id    = aws_apigatewayv2_api.api.id
  route_key = "Get /allitems"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"

}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_api.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"

}
