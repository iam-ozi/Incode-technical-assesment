terraform {
  backend "s3" {
    # Name of the S3 bucket to hold your Terraform state
    bucket = "my-tf-state-bucket-incode"

    # Path within the bucket for this environment’s state file
    key    = "Incode/dev/terraform.tfstate"
    region = "us-east-1"

  }
}
