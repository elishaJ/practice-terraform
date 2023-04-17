# Module for creating s3 buckets
module "bucket-creation" {
  source = "./modules/s3creation"
  count  = length(var.bucket)
  bucket = var.bucket[count.index]
  account-id = var.account-id[count.index]
  providers = {
    aws = aws.Oregon
  }
}

output "bucket-arn" {
  value = module.bucket-creation.*
}