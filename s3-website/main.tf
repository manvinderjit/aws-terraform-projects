# S3 Website Infrastructure

# S3 Website Module
module "s3_website" {
  source = "./modules/s3-website"

  bucket_name               = var.bucket_name
  environment               = var.environment
  index_document            = var.index_document
  error_document            = var.error_document
  path_source_website_files = "${path.root}/website-content"
  tags = var.tags
}
