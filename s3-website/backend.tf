# Backend Configuration

terraform {
  backend "s3" {    
    encrypt        = true
    use_lockfile   = true
  }
}