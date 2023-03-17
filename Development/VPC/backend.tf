terraform {
  backend "s3" {
    bucket = "mytfbucket5"
    key    = "tf/vpc/terraform.tfstate"
    region = "eu-west-1"
  }

}