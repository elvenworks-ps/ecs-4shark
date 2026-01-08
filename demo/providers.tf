provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tfstateecs4shark-demo"
    key    = "tfstateecs4shark-demo"
    region = "us-east-1"
  }
}
