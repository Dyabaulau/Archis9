resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket                  = aws_s3_bucket.lambda_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "lambda_hello" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "src.zip"
  source = data.archive_file.lambda_hello.output_path
  etag   = filemd5(data.archive_file.lambda_hello.output_path)
}

resource "aws_s3_bucket" "client_bucket" {
  bucket = "balapp-archi-front"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  policy = <<EOF
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : [
          "s3:*"
        ],
        "Resource" : "arn:aws:s3:::balapp-archi-front/*"
      }
    ]
  }
  EOF
}

resource "aws_s3_bucket_object" "example" {
  bucket  = aws_s3_bucket.client_bucket.id
  key     = "config.env"
  content = <<EOF
LAMBDA_URL=${aws_apigatewayv2_stage.dev.invoke_url}/hello
EOF
}

resource "aws_s3_bucket_object" "client_build" {
  for_each     = fileset("${path.module}/../src/front/build/", "**")
  bucket       = aws_s3_bucket.client_bucket.id
  key          = each.value
  source       = "${path.module}/../src/front/build/${each.value}"
  etag         = filemd5("${path.module}/../src/front/build/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "stylesheet" {
  bucket              = aws_s3_bucket.client_bucket.id
  key                 = "${path.module}/../src/front/build/static/css/main.3ad67671.css"
  content_disposition = "text/css"
}
