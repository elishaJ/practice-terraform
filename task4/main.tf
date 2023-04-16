# Module for creating s3 buckets
module "bucket-creation" {
  source = "./modules/s3creation"
  count  = length(var.bucket)
  bucket = var.bucket[count.index]
  providers = {
    aws = aws.Oregon
  }
}

# Resource to create IAM policy for bucket read/write access
resource "aws_iam_policy" "allow_access_from_another_account" {
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  name   = "task3-crossaccountbucketpolicy"
}

# IAM policy definition
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
    resources = ["arn:aws:s3:::tf-bucket-task-*"]
  }
  statement {
    actions = [
      "s3:GetOjbect",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::tf-bucket-task-*/*"]
  }
}

# Create role to access bucket
resource "aws_iam_role" "bucket-shared-access" {
  name               = "cross-account-bucket-access"
  assume_role_policy = data.aws_iam_policy_document.cross-account-bucket-access-policy.json
}

# Allow other account to assume role
data "aws_iam_policy_document" "cross-account-bucket-access-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["447743287036"]
    }
  }
}

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = aws_iam_role.bucket-shared-access.name
  policy_arn = aws_iam_policy.allow_access_from_another_account.arn
}

