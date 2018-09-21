##
## based on an excellent terrform for lambda example:
## https://www.terraform.io/docs/providers/aws/guides/serverless-with-aws-lambda-and-api-gateway.html
##


provider "aws" {
  region = "eu-central-1"
  }

variable "app_version" {
}

resource "aws_lambda_function" "PyLambdaFunction" {
  function_name = "PythonEvalLambda"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "terraform-serverless-python"
  s3_key    = "v${var.app_version}/python.zip"

  # "main" is the filename within the zip file (main.py) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "lambda.lambda_handler"
  runtime = "python3.6"

  role = "${aws_iam_role.lambda_exec.arn}"
}


# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda_python"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
  "Action": "sts:AssumeRole",
  "Principal": {
    "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
}
EOF
}
