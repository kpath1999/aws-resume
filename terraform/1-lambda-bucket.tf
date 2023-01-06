// S3 bucket names must be unique. Use a random pet generator and append it to the bucket name (e.g: lambda-fitting-alien).
resource "random_pet" "lambda_bucket_name" {
    prefix = "lambda"   // A string to prefix the name with
    length = 2          // Length (in words) of the pet name
    separator = "-"     // Character to separate words in the pet name
}

// Create the S3 bucket with the generated name (random_pet.lambda_bucket_name.id)
resource "aws_s3_bucket" "lambda_bucket" {
    bucket          = random_pet.lambda_bucket_name.id  //Name of the bucket, id (string read-only): the random pet name
    force_destroy   = true                              //All objects will be deleted when the bucket is destroyed
}

// Block all public access to this bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
    bucket              = aws_s3_bucket.lambda_bucket.id    //S3 bucket name to which this public access block should be applied
    block_public_acls   = true
    block_public_policy = true
    ignore_public_acls  = true
}