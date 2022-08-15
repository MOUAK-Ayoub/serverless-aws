variable "region" {
  type    = string
  default = "us-east-1"
}

variable "accountId" {

  type    = string
  default = "377938492601"
}

variable "dynamodb-table" {
  type    = string
  default = "inventory"
}

variable "schedule_expression" {
  type    = string
  default = "rate(1 hour)"
}
