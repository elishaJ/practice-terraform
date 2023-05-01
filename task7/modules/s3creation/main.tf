# Create bucket
resource "aws_s3_bucket" "bucket-for-git-actions" {
  bucket        = "tf-bucket-created-by-gitaction"
  force_destroy = true
}

# Resource to block all public access to bucket
resource "aws_s3_bucket_public_access_block" "block-bucket-public-access" {
  bucket = aws_s3_bucket.bucket-for-git-actions.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket-for-git-actions.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket-arn" {
  value = aws_s3_bucket.bucket-for-git-actions.arn
}
