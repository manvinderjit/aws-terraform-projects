# 1. Allow GitHub Repo Access to AWS
The first step is to allow the GitHub repository to access the AWS infrastructure. We are going to use STS roles for this.

## 1.A Create IAM Role

Log in to your AWS console.
Got to IAM (Identity and Access management).
Select 

Create a New IAM Role for this repo

Better to have separate roles for each distinct repo.

1.B Create an S3 Bucket to Store Terraform State

1.C Add Roles for 
    a. Providing access to terraform to the state bucket
    b. Providing access to terraform via policies to create and manipulate desired resources
