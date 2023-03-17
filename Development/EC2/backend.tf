terraform {
  backend "s3" {
    bucket = "mytfbucket5"
    key    = "tf/ec2/terraform.tfstate"
    region = "eu-west-1"
  }

}