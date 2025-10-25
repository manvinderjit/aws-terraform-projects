# Core Configuration
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "bucket_name" {
  description = "Name for the S3 bucket"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens, starting and ending with alphanumeric characters."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# S3 Website Configuration
variable "index_document" {
  description = "Index document for the website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Error document for the website"
  type        = string
  default     = "error.html"
}

# Global Tags
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "GitAwsTerraformProjects"
    Project   = "S3Website"
  }
}


variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_lifecycle" {
  description = "Enable S3 bucket lifecycle management"
  type        = bool
  default     = true
}

variable "logging_bucket" {
  description = "S3 bucket for access logging (optional)"
  type        = string
  default     = ""
}

variable "cors_rules" {
  description = "List of CORS rules for the S3 bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = []
}

variable "routing_rules" {
  description = "List of routing rules for the website"
  type = list(object({
    condition = object({
      key_prefix_equals = string
    })
    redirect = object({
      replace_key_prefix_with = string
    })
  }))
  default = []
}

# CloudFront Configuration
variable "domain_aliases" {
  description = "List of domain aliases for the CloudFront distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS (must be in us-east-1)"
  type        = string
  default     = null
}

variable "cloudfront_comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = "Static website distribution managed by Terraform"
}

variable "cloudfront_price_class" {
  description = "Price class for the CloudFront distribution"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.cloudfront_price_class)
    error_message = "Price class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}

variable "web_acl_id" {
  description = "AWS WAF web ACL ID to associate with the distribution"
  type        = string
  default     = null
}

variable "default_cache_behavior" {
  description = "Default cache behavior configuration"
  type = object({
    allowed_methods                = list(string)
    cached_methods                 = list(string)
    compress                       = bool
    viewer_protocol_policy         = string
    cache_policy_id                = optional(string)
    origin_request_policy_id       = optional(string)
    response_headers_policy_id     = optional(string)
    # Legacy cache settings (used when cache_policy_id is null)
    forward_query_string           = optional(bool, false)
    forward_headers                = optional(list(string), [])
    forward_cookies                = optional(string, "none")
    whitelisted_cookies            = optional(list(string), [])
    min_ttl                        = optional(number, 0)
    default_ttl                    = optional(number, 86400)
    max_ttl                        = optional(number, 31536000)
    lambda_function_associations   = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = optional(bool, false)
    })), [])
    function_associations          = optional(list(object({
      event_type   = string
      function_arn = string
    })), [])
  })
  default = {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
  }
}

variable "ordered_cache_behaviors" {
  description = "List of ordered cache behaviors for different paths"
  type = list(object({
    path_pattern                   = string
    allowed_methods                = list(string)
    cached_methods                 = list(string)
    target_origin_id               = string
    compress                       = bool
    viewer_protocol_policy         = string
    cache_policy_id                = optional(string)
    origin_request_policy_id       = optional(string)
    response_headers_policy_id     = optional(string)
    # Legacy cache settings
    forward_query_string           = optional(bool)
    forward_headers                = optional(list(string))
    forward_cookies                = optional(string)
    whitelisted_cookies            = optional(list(string))
    min_ttl                        = optional(number)
    default_ttl                    = optional(number)
    max_ttl                        = optional(number)
    lambda_function_associations   = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = optional(bool, false)
    })))
    function_associations          = optional(list(object({
      event_type   = string
      function_arn = string
    })))
  }))
  default = []
}

variable "custom_error_responses" {
  description = "List of custom error responses"
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = [
    {
      error_code         = 404
      response_code      = 404
      response_page_path = "/error.html"
    },
    {
      error_code         = 403
      response_code      = 404
      response_page_path = "/error.html"
    }
  ]
}

variable "geo_restriction" {
  description = "Geographic restriction configuration"
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = {
    restriction_type = "none"
    locations        = []
  }
}

variable "cloudfront_logging_config" {
  description = "CloudFront access logging configuration"
  type = object({
    bucket          = string
    prefix          = string
    include_cookies = optional(bool, false)
  })
  default = null
}
