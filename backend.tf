terraform {
  backend "s3" {
    bucket = "digiboss-terraform-bank-app"
    key    = "production/terraform.tfstate"
    region = "us-east-1"
  }

}
