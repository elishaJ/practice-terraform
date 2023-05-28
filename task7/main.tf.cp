resource "aws_iam_user" "git-action-user" {
  name = "IAM-gitaction-user"
}

data "aws_iam_policy_document" "s3_bucket_policy-definition" {
  statement {
    sid       = "AllowS3BucketCreation"
    effect    = "Allow"
    actions   = ["s3:CreateBucket"]
    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_policy" "s3_bucket_policy" {
  name   = "s3-bucket-policy-for-gitaction"
  policy = data.aws_iam_policy_document.s3_bucket_policy-definition.json
} 
