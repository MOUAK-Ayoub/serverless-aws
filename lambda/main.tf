
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.python_script["filename"]
  output_path = var.python_script["zip_name"]
}

resource "aws_lambda_function" "lambda" {

  filename         = var.python_script["zip_name"]
  function_name    = var.python_script["function_name"]
  role             = aws_iam_role.role_for_lambda.arn
  handler          = var.python_script["handler"]
  source_code_hash = filebase64sha256(var.python_script["zip_name"])

  runtime = "python3.9"

  depends_on = [aws_iam_role.role_for_lambda, aws_iam_role_policy_attachment.lambda]

}





