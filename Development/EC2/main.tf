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
module "sg" {
  source = "../../Modules/securitygrp"
  vpc_id = data.terraform_remote_state.tf.outputs.vpc_id
  pri_rds_cidr = data.terraform_remote_state.tf.outputs.private_rds_cidr
}
module "elb" {
  source  = "../../modules/elb"
  pub_sub = data.terraform_remote_state.tf.outputs.pub_sub
  albsg   = module.sg.albsg
  vpc_id  = data.terraform_remote_state.tf.outputs.vpc_id
}
module "myec2" {
  source        = "../../modules/asg"
  instance_type = "t2.micro"
  vpc_id        = data.terraform_remote_state.tf.outputs.vpc_id
  ami_id        = "ami-0f7c07c27e040bac8"
  pri_sub_web   = data.terraform_remote_state.tf.outputs.priweb
  tgarn         = module.elb.tgarn
  asgsg         = module.sg.asgsg

}

output "albsg" {
  value = module.sg.albsg
}
output "asgsg" {
  value = module.sg.asgsg
}
output "tgarn" {
  value = module.elb.tgarn

}
output "rdssg" {
  value = module.sg.rdssg1
}
  