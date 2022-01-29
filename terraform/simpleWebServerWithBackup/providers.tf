terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.35.0"
    }
  }

  backend "s3" {
    bucket         = "s3.sbt.com.terraform.state"
    key            = "simpleWebServerWithBackup/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "sbt.com.terraform.lock.db"
    encrypt        = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = var.region
  access_key = var.ACCESS_KEY
  secret_key = var.SECRET_KEY
}