resource "aws_dynamodb_table" "basic_dynamo" {

  hash_key = "uuid"
  name     = "machin"

  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "uuid"
    type = "S"
  }
}