# S3 Website Infrastructure

# S3 Website Module
module "s3_website" {
  source = "./modules/s3-website"

  bucket_name               = var.bucket_name  
  index_document            = var.index_document
  error_document            = var.error_document
  path_source_website_files = "${path.root}/website-content"
  tags = var.tags
}

# CloudFront Distribution Module
module "cloudfront" {
  source = "./modules/cloudfront"

  distribution_name     = "${var.bucket_name}-cdn"
  s3_bucket_id          = module.s3_website.bucket_id
  s3_bucket_domain_name = module.s3_website.bucket_regional_domain_name

  # Domain configuration
  default_root_object = var.index_document

  # Distribution settings
  comment     = var.cloudfront_comment
  price_class = var.price_class
}

# S3 Bucket Policy (created after CloudFront)
resource "aws_s3_bucket_policy" "website" {
  bucket = module.s3_website.bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
  
  depends_on = [module.cloudfront]  # Explicit dependency
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_website.bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.distribution_arn]
    }
  }
}
