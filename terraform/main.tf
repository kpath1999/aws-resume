terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            Version = "~>3.27"
        }
    }
    required_version = ">=0.14.9"

    backend "s3" {
        bucket = "tf-remote-state-orangutan"
        key    = "arn:aws:s3:::tf-remote-state-orangutan"
        region = "east-us-1"
    }
}

provider "aws" {
    version = "~>3.0"
    region  = "east-us-1"
}