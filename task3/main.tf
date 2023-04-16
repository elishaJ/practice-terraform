resource "aws_s3_bucket" "bucket-for-shared-access" {
  bucket = "bucket-101-101"
}

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

resource "aws_iam_policy" "allow_access_from_another_account" {
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  name = "task3-crossaccountbucketpolicy"
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::bucket-for-shared-access.id"]
  }
  statement {
    actions = [
      "s3:GetOjbect",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::bucket-for-shared-access.id/*"]
  }
}

data "aws_iam_policy_document" "cross-account-bucket-access-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["774858124849"]
    }
  }
}

resource "aws_iam_role" "bucket-shared-access" {
  name               = "cross-account-bucket-access"
  assume_role_policy = data.aws_iam_policy_document.cross-account-bucket-access-policy.json
}


resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = aws_iam_role.bucket-shared-access.name
  policy_arn = aws_iam_policy.allow_access_from_another_account.arn
}
