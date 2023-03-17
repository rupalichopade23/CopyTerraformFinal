terraform {
  backend "s3" {
    bucket = "mytfbucket5"
    key    = "tf/rds/terraform.tfstate"
    region = "eu-west-1"
  }

}