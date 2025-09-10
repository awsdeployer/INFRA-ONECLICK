terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "awsdeployer"           # Your S3 bucket name
    key            = "terraform.tfstate"     # Path inside bucket
    region         = var.aws_region          # Use the same region as provider
    dynamodb_table = "terraform-locks"       # DynamoDB table for locking
    encrypt        = true                    # Encrypt the state file
  }
}

provider "aws" {
  region = var.aws_region
}

