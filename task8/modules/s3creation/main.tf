# Create bucket
resource "aws_s3_bucket" "bucket-for-git-actions" {
  bucket        = "s3-bucket-to-store-tfstate"
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

# role to be assumed by github
resource "aws_iam_role" "github_workflow_role" {
  name               = "role_assumed_by_github"
  assume_role_policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::452449161976:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:elishaJ/practice-terraform:*"
                }
            }
        }
    ]
  }
 EOF
}

# create IAM policy for bucket access to store state file
resource "aws_iam_policy" "github_state_bucket_access_policy" {
  policy = data.aws_iam_policy_document.github_state_bucket_access_policy_def.json
  name   = "state-bucket-access-for-github-policy"
}

# policy definition
data "aws_iam_policy_document" "github_state_bucket_access_policy_def" {
  statement {
    actions = [
      "s3:GetOjbect",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::s3-bucket-to-store-tfstate/*",
      "arn:aws:s3:::s3-bucket-to-store-tfstate"
    ]
  }
}
# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "attach-state-bucket-policy-to-role" {
  role       = aws_iam_role.github_workflow_role.name
  policy_arn = aws_iam_policy.github_state_bucket_access_policy.arn
}


# create IAM policy to allow github to create bucket
resource "aws_iam_policy" "github_create_bucket_access_policy" {
  policy = data.aws_iam_policy_document.github_create_bucket_access_policy_def.json
  name   = "create-bucket-access-for-github-policy"
}

# policy definition
data "aws_iam_policy_document" "github_create_bucket_access_policy_def" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:CreateBucket",
      "s3:DeleteObject",
      "s3:DeleteBucket"
    ]
    resources = ["*"]
  }
}
# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "attach-create-bucket-policy-to-role" {
  role       = aws_iam_role.github_workflow_role.name
  policy_arn = aws_iam_policy.github_create_bucket_access_policy.arn
}
