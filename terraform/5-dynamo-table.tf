resource "aws_dynamodb_table" "visits_table" {
    name = "VisitorCount"
    hash_key = "ID"
    read_capacity = 10
    write_capacity = 10
    attribute {
        name = "ID"
        type = "S"
    }
}

resource "aws_dynamodb_table_item" "table_schema" {
    table_name  = aws_dynamodb_table.visits_table.name
    hash_key    = aws_dynamodb_table.visits_table.hash_key
    item = <<ITEM
{
    "ID": {"S": "#"},
    "Visits": {"N": "0"}
}
ITEM
}