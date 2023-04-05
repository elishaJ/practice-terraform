#Resource to create s3 bucket
resource "aws_s3_bucket" "my-bukets" {
  count = length(var.bucket_list)
  bucket = var.bucket_list[count.index]
  #for_each = toset(var.bucket_list)
  #bucket = "mybuck12122121mkmk"
}
