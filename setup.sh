#!/bin/bash

# Initialize Terraform
terraform init

# Plan
terraform plan

# Apply (comment out if you wanna run manually)
# terraform apply -auto-approve

# Download public sample CSV (products data from a GitHub example)
curl -O https://raw.githubusercontent.com/graphql-compose/graphql-compose-examples/master/examples/northwind/data/csv/products.csv

# Get bucket name from Terraform output
BUCKET_NAME=$(terraform output -raw bucket_name)

# Upload to S3 (in /data/ folder for the table location)
aws s3 cp products.csv s3://$BUCKET_NAME/data/products.csv

echo "Data uploaded! Head to Athena console to query."