resource "aws_s3_bucket" "east-1-buck" {
  bucket = "tf-region-east-1"
  provider = aws.us-east-1

  tags = {
    Name        = "Bucket Number 1"
  }
}

resource "aws_s3_bucket" "east-2-buck" {
  bucket = "tf-region-bucket-east-2"
  provider = aws.us-east-2

  tags = {
    Name        = "Bucket Number 2"
  }
}

resource "aws_s3_bucket" "west-1-buck" {
  bucket = "tf-region-bucket-west-1"
  provider = aws.us-west-1

  tags = {
    Name        = "Bucket Number 3"
  }
}

resource "aws_s3_bucket" "west-2-buck" {
  bucket = "tf-region-bucket-west-2"
  provider = aws.us-west-2

  tags = {
    Name        = "Bucket Number 4"
  }
}
