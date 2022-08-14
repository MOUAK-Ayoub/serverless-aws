resource "aws_iam_role" "role_for_lambda" {
  name = var.role_lambda["rolename"]

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

  name = var.role_lambda["policyname"]

  policy = file(var.role_lambda["policypath"])

}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.role_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda.arn
}

