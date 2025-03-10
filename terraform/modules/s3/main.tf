resource "aws_s3_bucket" "content_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }

  lifecycle {
    prevent_destroy = true
  }
}