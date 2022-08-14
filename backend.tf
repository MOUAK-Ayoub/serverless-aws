terraform {
  required_version = ">=1.0.0"
  backend "s3" {
    profile = "default"
    region  = "us-east-1"
    bucket  = "terraformstatefile2021"
    key     = "terraformstatefile"

  }

}
