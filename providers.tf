provider "aws" {
  region  = "us-east-1"
  profile = "4shark"
}

terraform {
  backend "s3" {
    bucket  = "tfstate-asg-lt"
    key     = "tfstate-asg-lt"
    region  = "us-east-1"
    profile = "4shark"
  }
}