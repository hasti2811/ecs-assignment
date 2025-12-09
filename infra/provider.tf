terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.25.0"
    }
  }

  backend "s3" {
    bucket         = "hasti-ecs-assignment-s3-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "ecs-assignment-statelock"
  }
}

provider "aws" {
  region = "eu-west-2"
}