# Backend Configuration

terraform {
  backend "s3" {
    region         = var.aws_region
    encrypt        = true
    use_lockfile   = true
  }
}