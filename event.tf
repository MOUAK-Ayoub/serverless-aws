


resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "lambda-rule"
  description         = "Rule to execute lambda function every 5 minutes"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "event_target" {
  arn  = module.lambda_dynamodb.lambda_arn
  rule = aws_cloudwatch_event_rule.event_rule.name

}

resource "aws_s3_bucket_notification" "aws-lambda-trigger-S3" {
  bucket = aws_s3_bucket.products.id

  lambda_function {
    lambda_function_arn = module.lambda_s3_to_dynamodb.lambda_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "item"
    filter_suffix       = ".txt"
  }
}

resource "aws_lambda_event_source_mapping" "dynamodb_streams" {
  event_source_arn  = aws_dynamodb_table.inventory-dynamodb-table.stream_arn
  function_name     =  module.lambda_dynamodb_streams.lambda_arn
  starting_position = "LATEST"
  
}
