resource "aws_lambda_function" "hello" {
  function_name = "hello"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_hello.key
  role          = aws_iam_role.hello_lambda_exec.arn
  handler       = "main.helloworld"
  runtime       = "python3.8"

  # You should upload your zip file containing your code here
  # or use S3 bucket to store your code and fetch it 
  # with S3 url in the below source_code_hash
  # or use `terraform-aws-lambda` module to make it easier
  source_code_hash = data.archive_file.lambda_hello.output_base64sha256

  environment {
    
    variables = {
      FASTAPI_ENV = "production"
    }
  }
}

resource "aws_lambda_function" "lambda_post_hello" {
  function_name = "post_hello"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_hello.key
  role          = aws_iam_role.hello_lambda_exec.arn
  handler       = "main.posthello"
  runtime       = "python3.8"

  # You should upload your zip file containing your code here
  # or use S3 bucket to store your code and fetch it 
  # with S3 url in the below source_code_hash
  # or use `terraform-aws-lambda` module to make it easier
  source_code_hash = data.archive_file.lambda_hello.output_base64sha256

  environment {
    
    variables = {
      FASTAPI_ENV = "production"
    }
  }
}

data "archive_file" "lambda_hello" {
  type = "zip"
  source_dir = "${path.module}/../src"
  output_path = "${path.module}/../output/src.zip"
}