resource "aws_dynamodb_table" "email_limits" {
  name         = "EmailLimits"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }
}
