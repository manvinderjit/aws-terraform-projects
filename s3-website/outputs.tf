# S3 Website Outputs

# S3 Bucket Outputs
output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.s3_website.bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3_website.bucket_arn
}

output "s3_website_endpoint" {
  description = "The S3 website endpoint URL"
  value       = module.s3_website.website_endpoint
}

output "s3_website_domain" {
  description = "The domain of the S3 website endpoint"
  value       = module.s3_website.website_domain
}

