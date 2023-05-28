# Create bucket
resource "aws_s3_bucket" "my-bucket" {
  bucket        = "tf-bucket-created-by-git-action"
  force_destroy = true
}

# Resource to block all public access to bucket
resource "aws_s3_bucket_public_access_block" "block-bucket-public-access" {
  bucket = aws_s3_bucket.my-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket-arn" {
  value = aws_s3_bucket.my-bucket.arn
}
