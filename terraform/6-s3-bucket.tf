// S3 bucket names must be unique
resource "random_pet" "s3_bucket_name" {
    prefix = "s3"       // A string to prefix the name with
    length = 2          // Length (in words) of the pet name
    separator = "-"     // Character to separate words in the pet name
}

resource "aws_s3_bucket" "s3Bucket" {
    bucket    = random_pet.s3_bucket_name.id
    acl       = "public-read"
    
    policy  = <<EOF
{
    "id" : "MakePublic",
    "version" : "2012-10-17",
    "statement" : [
        {
            "action" : ["s3:GetObject"],
            "effect" : "Allow",
            "resource" : "arn:aws:s3:::random_pet.s3_bucket_name.id/*",
            "principal" : "*"
        }
    ]
}
EOF

    website {
        index_document = "index.html"
    }
}