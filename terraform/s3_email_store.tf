resource "aws_s3_bucket" "email_bucket" {
  bucket = "13techs-email-bucket"
  acl    = "private"
}
