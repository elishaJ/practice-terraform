module "bucket-creation" {
  source = "./modules/s3creation"
  providers = {
    aws = aws.Oregon
  }
}
output "bucket-arn" {
  value = module.bucket-creation.bucket-arn
}
