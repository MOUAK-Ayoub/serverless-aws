variable "region" {
  type    = string
  default = "us-east-1"
}
variable "dynamodb-table" {
  type    = string
  default = "Inventory"
}

variable "schedule_expression" {
  type    = string
  default = "rate(5 minutes)"
}