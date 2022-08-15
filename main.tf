provider "aws" {

  region = var.region
  alias  = "region-monitoring"
}

module "lambda_dynamodb" {
  source = "./lambda/"
  python_script = {
    filename      = "./python/dynamodb_backup.py"
    zip_name      = "./python/dynamodb_backup.zip"
    function_name = "dynamodb_backup"
    handler       = "dynamodb_backup.lambda_handler"

  }
  role_lambda = {

    rolename   = "role_for_lambda"
    policyname = "policy_for_lambda"
    policypath = "./policy/lambda_policy.json"

  }

}

module "lambda_s3_to_dynamodb" {
  source = "./lambda/"
  python_script = {
    filename      = "./python/create_item_dynamodb.py"
    zip_name      = "./python/create_item_dynamodb.zip"
    function_name = "create_item_dynamodb"
    handler       = "create_item_dynamodb.lambda_S3_to_dynamodb_handler"

  }
  role_lambda = {

    rolename   = "role_for_lambda_s3"
    policyname = "policy_for_lambda_s3"
    policypath = "./policy/lambda_S3_event_policy.json"

  }

}

module "lambda_api" {
  source = "./lambda/"
  python_script = {
    filename      = "./python/rest_dynamodb.py"
    zip_name      = "./python/rest_dynamodb.zip"
    function_name = "rest_dynamodb"
    handler       = "rest_dynamodb.lambda_handler"

  }
  role_lambda = {

    rolename   = "role_for_lambda_api"
    policyname = "policy_for_lambda_api"
    policypath = "./policy/lambda_api.json"

  }
}


module "lambda_dynamodb_streams" {
  source = "./lambda/"
  python_script = {
    filename      = "./python/dynamodb_streams.py"
    zip_name      = "./python/dynamodb_streams.zip"
    function_name = "dynamodb_streams"
    handler       = "dynamodb_streams.lambda_dynamodb_streams_handler"

  }
  role_lambda = {

    rolename   = "role_for_lambda_dynamodb_streams"
    policyname = "policy_for_lambda_dynamodb_streams"
    policypath = "./policy/lambda_dynamo_streams.json"

  }
}

# Permission to eventbridge to invoke lambda
resource "aws_lambda_permission" "event-invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_dynamodb.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
  depends_on    = [aws_cloudwatch_event_rule.event_rule]

}


resource "aws_lambda_permission" "s3-invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_s3_to_dynamodb.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.products.arn
}