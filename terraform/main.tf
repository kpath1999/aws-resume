terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
        random = {
            source = "hashicorp/random"
        }
        archive = {
            source = "hashicorp/archive"
        }
    }

    required_version = "~> 1.0"

    backend "s3" {
        bucket = "tf-remote-state-orangutan"
        key    = "terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region  = "us-east-1"
}