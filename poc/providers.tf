provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tfstateecs4shark-poc"
    key    = "tfstateecs4shark-poc"
    region = "us-east-1"
  }
}
