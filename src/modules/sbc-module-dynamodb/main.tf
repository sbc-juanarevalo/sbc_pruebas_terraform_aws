variable "table_name" {
  type        = string
  description = "Tabla de prueba"
}

variable "hash_key" {
  type        = string
  description = "The hash_key for table"
}

variable "hash_key_type" {
  type        = string
  description = "The hash_key_type for table"
}

variable "other_attributes" {
  description = "The attributes of the Table"
}

variable "global_secondary_index" {
  description = "The attributes of the Table"
}

variable "tags" {
  description = "The tags of the Table"
}

resource "aws_dynamodb_table" "table_dynamodb" {
  name         = "${var.table_name}-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  for_each = var.other_attributes
  attribute {
    name = each.value.name
    type = each.value.type
  }

  global_secondary_index {
    for_each = {
      for name, hash_key in var.global_secondary_index : name => hash_key
    }
  }

  tags = var.tags

}