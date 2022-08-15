resource "aws_s3_bucket" "products" {
  bucket = "products4645fzeff"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.products.id
  acl    = "private"
}

