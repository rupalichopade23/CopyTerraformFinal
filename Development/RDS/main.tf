provider "aws" {
  region = "eu-west-1"
}

terraform {

}
data "terraform_remote_state" "tf" {
  backend = "s3"
  config = {
    bucket = "mytfbucket5"
    key    = "tf/vpc/terraform.tfstate"
    region = "eu-west-1"

  }

}
data "terraform_remote_state" "tf1" {
  backend = "s3"
  config = {
    bucket = "mytfbucket5"
    key    = "tf/ec2/terraform.tfstate"
    region = "eu-west-1"

  }

}
module "rds" {
  source = "../../modules/rds"
  vpc_id = data.terraform_remote_state.tf.outputs.vpc_id
  prirds = data.terraform_remote_state.tf.outputs.prirds
  rdssg1 = data.terraform_remote_state.tf1.outputs.rdssg
  asgsg  = data.terraform_remote_state.tf1.outputs.asgsg
}
