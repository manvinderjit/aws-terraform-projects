resource "aws_s3_bucket" "example" {

  tags = {
    ManagedBy = "GitAwsTerraformProjects"
    Project   = "GitAwsTerraformProjects"
  }
}
