provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tfstateecs4shark-atento"
    key    = "tfstateecs4shark-atento"
    region = "us-east-1"
  }
}