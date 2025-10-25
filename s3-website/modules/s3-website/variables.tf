# S3 Website Module - Variables

variable "bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens, starting and ending with alphanumeric characters."
  }
}

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

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default = {
    ManagedBy = "GitAwsTerraformProjects"
    Project   = "S3Website"
  }
}

variable "path_source_website_files" {
  description = "Path within the modules from where the website files will be copied"
  type        = string
}