
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./dynamodb_backup.py"
  output_path = "dynamodb_backup.zip"
}

resource "aws_lambda_function" "test_lambda" {

  filename         = "dynamodb_backup.zip"
  function_name    = "dynamodb_backup"
  role             = aws_iam_role.role_for_lambda.arn
  handler          = "dynamodb_backup.lambda_handler"
  source_code_hash = filebase64sha256("dynamodb_backup.zip")

  runtime = "python3.9"

  depends_on = [aws_iam_role.role_for_lambda, aws_iam_role_policy_attachment.lambda]

}


resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "lambda-rule"
  description         = "Rule to execute lambda function every 5 minutes"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "event_target" {
  arn        = aws_lambda_function.test_lambda.arn
  rule       = aws_cloudwatch_event_rule.event_rule.name
  depends_on = [aws_lambda_function.test_lambda]

}

