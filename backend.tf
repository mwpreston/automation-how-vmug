terraform {
  backend "s3" {
    bucket = "mwpreston-tfstate"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}