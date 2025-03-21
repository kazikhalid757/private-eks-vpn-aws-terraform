terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-kazitamim"   # Replace with your S3 bucket name
    key            = "terraform.tfstate"          # Path to store state file in S3
    region         = "us-east-1"                  # Change if using a different region
    encrypt        = true                         # Encrypt the state file
    dynamodb_table = "terraform-lock"             # Optional: for state locking
  }
}