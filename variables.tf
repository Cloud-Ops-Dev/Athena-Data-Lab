variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Unique S3 bucket name for data"
  default     = "athena-lab-data-bucket"
}

variable "database_name" {
  description = "Athena/Glue database name"
  default     = "athena_lab_db"
}

variable "table_name" {
  description = "Glue table name"
  default     = "products"
}