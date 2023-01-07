terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.21.0"
        }
        random = {
            source = "hashicorp/random"
            version = "~> 3.3.0"
        }
        archive = {
            source = "hashicorp/archive"
            version = "~> 2.2.0"
        }
    }
    
    required_version = "~> 1.0"

    backend "s3" {
        bucket = "tf-remote-state-orangutan"
        key    = "arn:aws:s3:::tf-remote-state-orangutan"
        region = "us-east-1"
    }
}

provider "aws" {
    region  = "us-east-1"
}