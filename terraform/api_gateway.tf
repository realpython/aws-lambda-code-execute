## API Gateway config
resource "aws_api_gateway_rest_api" "PyAPI" {
  name        = "TfServerlessPythonAPI"
  description = "API for Serverless Python Application Example"
  }

resource "aws_api_gateway_resource" "ExecutePyResource" {
  rest_api_id = "${aws_api_gateway_rest_api.PyAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.PyAPI.root_resource_id}"
  path_part   = "pyexecute"
  }

resource "aws_api_gateway_method" "ExecutePyMethod" {
  rest_api_id   = "${aws_api_gateway_rest_api.PyAPI.id}"
  resource_id   = "${aws_api_gateway_resource.ExecutePyResource.id}"
  http_method   = "POST"
  authorization = "NONE"
  }

## Lambda Integration  
resource "aws_api_gateway_integration" "LambdaIntegration" {
  rest_api_id = "${aws_api_gateway_rest_api.PyAPI.id}"
  resource_id = "${aws_api_gateway_resource.ExecutePyResource.id}"
  http_method = "${aws_api_gateway_method.ExecutePyMethod.http_method}"

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = "${aws_lambda_function.PyLambdaFunction.invoke_arn}"
  }

## Response mapping
resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.PyAPI.id}"
  resource_id = "${aws_api_gateway_resource.ExecutePyResource.id}"
  http_method = "${aws_api_gateway_method.ExecutePyMethod.http_method}"
  status_code = "200"
  }

resource "aws_api_gateway_integration_response" "LambdaIntegrationResponse" {
  rest_api_id = "${aws_api_gateway_rest_api.PyAPI.id}"
  resource_id = "${aws_api_gateway_resource.ExecutePyResource.id}"
  http_method = "${aws_api_gateway_method.ExecutePyMethod.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"
  depends_on = ["aws_api_gateway_integration.LambdaIntegration"]
  }                    
 
## API DEPLOYMENT
resource "aws_api_gateway_deployment" "PyAPIDeployment" {
  depends_on = [
    "aws_api_gateway_integration.LambdaIntegration"
    ]

  rest_api_id = "${aws_api_gateway_rest_api.PyAPI.id}"
  stage_name  = "v1"
  }

## Permission for API Gateway DEPLOYMENT to access Lambda 
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.PyLambdaFunction.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.PyAPIDeployment.execution_arn}/*/*"
  }

## Permission for API Gateway REST API to access Lambda
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowTfServerlessPythonAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.PyLambdaFunction.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.PyAPI.execution_arn}/*/*/*"
  }

output "base_url" {
  value = "${aws_api_gateway_deployment.PyAPIDeployment.invoke_url}"
  }
