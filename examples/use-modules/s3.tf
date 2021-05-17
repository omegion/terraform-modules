resource "aws_s3_bucket" "bucket_module_1" {
  bucket = "module-bucket-${module.module_1.name}"
}
