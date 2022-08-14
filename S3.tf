resource "aws_s3_bucket" "example" {
  bucket = "products"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.example.id
  acl    = "public"
}