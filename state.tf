//terraform {
//  backend "s3" {
//    bucket          = "d53-terraform-state-files"
//    key             = "ami/terraform.tfstate"
//    region          = "us-east-1"
//    dynamodb_table  = "terraform"
//  }
//}

provider "aws" {
  region = "us-east-1"
}

