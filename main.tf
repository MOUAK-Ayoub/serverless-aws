provider "aws" {

  region = var.region
  alias  = "region-monitoring"
}


resource "aws_iam_role" "role_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_for_lambda" {

  name = "policy_for_lambda"

  policy = file("./lambda_policy.json")

}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda.arn
}

# Permission to eventbridge to invoke lambda
resource "aws_lambda_permission" "event-invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event_rule.arn
  depends_on    = [aws_cloudwatch_event_rule.event_rule, aws_lambda_function.test_lambda]

}
