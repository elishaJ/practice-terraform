# Create bucket
resource "aws_s3_bucket" "bucket-for-shared-access" {
  bucket = var.bucket
}

output "bucket-arn" {
	value = aws_s3_bucket.bucket-for-shared-access.arn
}
# Resource to block all public access to bucket
resource "aws_s3_bucket_public_access_block" "block-bucket-public-access" {
  bucket = aws_s3_bucket.bucket-for-shared-access.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket-for-shared-access.id
  versioning_configuration {
    status = "Enabled"
  }
}
