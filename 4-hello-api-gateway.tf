// Integrating API gateway with Lambda
resource "aws_apigatewayv2_integration" "lambda_hello" {
    api_id              = aws_apigatewayv2_api.main.id              // API identifier
    integration_uri     = aws_lambda_function.hello.invoke_arn      // URI of the Lambda function
    integration_type    = "AWS_PROXY"                               // Supported for HTTP APIs
    integration_method  = "POST"                                    // Integration's HTTP method
}

// {}.id = integration identifier
resource "aws_apigatewayv2_route" "post_hello" {
    api_id      = aws_apigatewayv2_api.main.id
    route_key   = "POST /"
    target      = "integrations/${aws_apigatewayv2_integration.lambda_hello.id}"
}

// Allows API gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_gw" {
    statement_id    = "AllowExecutionFromAPIGateway"                        // A unique statement identifier
    action          = "lambda:InvokeFunction"                               // AWS Lambda action you want to allow
    function_name   = aws_lambda_function.hello.function_name               // Name of the Lambda function that's getting invoked
    principal       = "apigateway.amazonaws.com"                            // API gateway is the principal who is getting the permission
    source_arn      = "${aws_apigatewayv2_api.main.execution_arn}/*/*"      // ARN prefix in aws_lambda_permission's source_arn attribute
}

output "hello_base_url" {
    value = aws_apigatewayv2_stage.dev.invoke_url   // URL to invoke the API pointing to the stage
}