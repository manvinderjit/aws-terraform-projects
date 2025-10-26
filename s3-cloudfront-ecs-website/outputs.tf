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

# CloudFront Outputs
output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = module.cloudfront.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = module.cloudfront.distribution_arn
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront.distribution_domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = module.cloudfront.distribution_hosted_zone_id
}

output "cloudfront_status" {
  description = "The current status of the CloudFront distribution"
  value       = module.cloudfront.distribution_status
}

# Website URLs
output "website_url" {
  description = "The primary website URL (CloudFront if available, otherwise S3)"
  value       = length(var.domain_aliases) > 0 ? "https://${var.domain_aliases[0]}" : "https://${module.cloudfront.distribution_domain_name}"
}

output "s3_direct_url" {
  description = "Direct S3 website URL (for testing)"
  value       = "http://${module.s3_website.website_endpoint}"
}

# Deployment Information
output "deployment_info" {
  description = "Information for deploying content to the website"
  value = {
    s3_bucket_name         = module.s3_website.bucket_id
    cloudfront_distribution_id = module.cloudfront.distribution_id
    website_url           = length(var.domain_aliases) > 0 ? "https://${var.domain_aliases[0]}" : "https://${module.cloudfront.distribution_domain_name}"
    s3_sync_command       = "aws s3 sync ./website-content/ s3://${module.s3_website.bucket_id}/ --delete"
    invalidation_command  = "aws cloudfront create-invalidation --distribution-id ${module.cloudfront.distribution_id} --paths '/*'"
  }
}