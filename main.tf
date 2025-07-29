provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "${var.bucket_name}-${random_string.suffix.result}"
  tags = {
    Name = "AthenaLabDataBucket"
  }
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_athena_workgroup" "lab_workgroup" {
  name = "athena_lab_workgroup"
  configuration {
    result_configuration {
      output_location = "s3://${aws_s3_bucket.data_bucket.bucket}/query-results/"
    }
  }
}

resource "aws_glue_catalog_database" "lab_db" {
  name = var.database_name
}

resource "aws_glue_catalog_table" "products_table" {
  name          = var.table_name
  database_name = aws_glue_catalog_database.lab_db.name
  table_type = "EXTERNAL_TABLE"
  parameters = {
    "EXTERNAL" = "TRUE"
  }
  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data_bucket.bucket}/data/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    ser_de_info {
      name                  = "csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
        "quoteChar"     = "\""
        "escapeChar"    = "\\"
        "skip.header.line.count" = "1"  # Skip header row
      }
    }
    columns {
      name = "productID"
      type = "string"
    }
    columns {
      name = "productName"
      type = "string"
    }
    columns {
      name = "supplierID"
      type = "string"
    }
    columns {
      name = "categoryID"
      type = "string"
    }
 columns {
      name = "quantityPerUnit" # Match CSV
      type = "string"
    }
    columns {
      name = "unitPrice"       # Match CSV
      type = "double"          # Numeric
    }
    columns {
      name = "unitsInStock"    # Match CSV
      type = "int"             # Numeric
    }
    columns {
      name = "unitsOnOrder"    # Match CSV
      type = "int"
    }
    columns {
      name = "reorderLevel"    # Match CSV
      type = "int"
    }
    columns {
      name = "discontinued"    # Match CSV
      type = "int"             # 0/1 boolean in CSV
    }
  }
}

  output "bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}
