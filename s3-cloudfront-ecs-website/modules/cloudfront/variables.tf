# CloudFront Module - Variables

variable "distribution_name" {
  description = "Name for the CloudFront distribution"
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket ID for the origin"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "S3 bucket domain name for the origin"
  type        = string
}

variable "comment" {
  description = "Comment for the CloudFront distribution"
  type        = string
  default     = "Static website distribution"
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  type        = string
  default     = "index.html"
}

variable "enable_ipv6" {
  description = "Enable IPv6 for the distribution"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for the distribution"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Price class must be one of: PriceClass_All, PriceClass_200, PriceClass_100."
  }
}
