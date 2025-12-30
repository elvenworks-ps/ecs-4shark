provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tfstateecs4shark"
    key    = "tfstateecs4shark"
    region = "us-east-1"
  }
}
