resource "aws_dynamodb_table" "inventory-dynamodb-table" {

  name           = var.dynamodb-table
  hash_key       = "product_id"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "product_id"
    type = "S"
  }

  tags = {
    Name = "dynamodb-table-inventory"
  }
}
