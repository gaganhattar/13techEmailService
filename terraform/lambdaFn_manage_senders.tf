resource "aws_lambda_function" "email_limit_handler" {
  filename      = "email_limit_handler.zip"
  function_name = "emailLimitHandler"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "email_limit_handler.handler"
  runtime       = "nodejs14.x"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.email_limits.name
    }
  }

  source_code_hash = filebase64sha256("email_limit_handler.zip")
}


# iam policy for lambda fn to access dynamo db
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "dynamodb_policy"
  role = aws_iam_role.lambda_exec.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:GetItem"
      ],
      "Resource": "${aws_dynamodb_table.email_limits.arn}"
    }
  ]
}
EOF
}
