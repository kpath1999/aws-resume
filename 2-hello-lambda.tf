// Create a role named "hello-lambda"
// ERROR: failed to create IAM role (hello-lambda)
// tf-state-role is not authorized to perform => iam:CreateRole on hello-lambda
// no identity-based policy within tf-state-role allows the iam:CreateRole action

resource "aws_iam_role" "hello_lambda_exec" {
    name = "hello-lambda"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action"    = "sts:AssumeRole"
                "Effect"    = "Allow"
                "Sid"       = ""
                "Principal" = {
                "Service"   = "lambda.amazonaws.com"
                },
            }
        ]
    })
}

// Attach policy. Lambda would require access to CloudWatch to write logs.
resource "aws_iam_role_policy_attachment" "hello_cw_policy" {
    role        = aws_iam_role.hello_lambda_exec.name
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Attach policy. Lambda would require access to DynamoDB to update the visitor counter.
resource "aws_iam_role_policy_attachment" "hello_dynamo_policy" {
    role        = aws_iam_role.hello_lambda_exec.name
    policy_arn  = "arn:aws:iam::147457867989:policy/LambdaAccessToDynamo"
}

// Zipping the function code before sending it to S3
data "archive_file" "lambda_hello" {
    type        = "zip"
    source_dir  = "${path.root}/hello"
    output_path = "${path.root}/hello.zip"
}

// Provides an S3 object resource. Takes hello.zip code and stores it in the S3 bucket. output_base64sha256 is exported.
resource "aws_s3_object" "lambda_hello" {
    bucket = aws_s3_bucket.lambda_bucket.id                     // Specifies the bucket to put the object in
    key = "hello.zip"                                           // Name of the object once it is in the bucket
    source = data.archive_file.lambda_hello.output_path         // Zipped function code acting as the source
    etag = filemd5(data.archive_file.lambda_hello.output_path)  // Triggers updates when the function code changes
}

// Creating the Lambda function
resource "aws_lambda_function" "hello" {
    function_name       = "hello"                                               // Unique name of the Lambda function 
    role                = aws_iam_role.hello_lambda_exec.arn                    // Attaching the CW + DynamoDB IAM role

    s3_bucket           = aws_s3_bucket.lambda_bucket.id                        // S3 bucket location containing the function
    s3_key              = aws_s3_object.lambda_hello.key                        // S3 key of object containing the function

    runtime             = "python3.9"                                           // Identifier of the function's runtime
    handler             = "main.lambda_handler"                                 // Function entrypoint in your code
    source_code_hash    = data.archive_file.lambda_hello.output_base64sha256    // base64-encoded SHA256 checksum of output archive file
}

// Creating a log group to store the logs generated by the Lambda function
resource "aws_cloudwatch_log_group" "hello" {
    name                = "/aws/lambda/${aws_lambda_function.hello.function_name}"
    retention_in_days   = 14
}