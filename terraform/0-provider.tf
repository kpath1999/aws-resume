terraform {
    backend "s3" {
        bucket = "tf-remote-state-orangutan"
        key    = "terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region  = "us-east-1"
}