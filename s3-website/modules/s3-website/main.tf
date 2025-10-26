# S3 Website Module - Main Resources

# S3 Bucket for website hosting
resource "aws_s3_bucket" "website" {
  bucket = "${var.bucket_name}"
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Disabled"
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket website configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

locals {
  file_ext_map = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    png  = "image/png"
    jpg  = "image/jpeg"
    jpeg = "image/jpeg"
    gif  = "image/gif"
    svg  = "image/svg+xml"
  }
}

# --- Upload local website files ---
resource "aws_s3_object" "website_files" {
  for_each = fileset(var.path_source_website_files, "**")

  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = "${var.path_source_website_files}/${each.value}"
  etag         = filemd5("${var.path_source_website_files}/${each.value}")
  content_type = lookup(
    local.file_ext_map,
    lower(regex("^.*\\.([^.]+)$", each.value)[0]),
    "text/plain"
  )
}

