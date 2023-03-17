provider "aws" {
  region = "eu-west-1"
}



module "my_vpc" {
  source   = "../../Modules/vpc"
 # vpc_cidr = "192.168.0.0/16"
  vpc_cidr = var.vpc_cidr
  vpc_id   = module.my_vpc.vpc_id
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
  #private_rds_cidr = module.my_vpc.pri_rds_cidr
}

output "vpc_id" {
  value = module.my_vpc.vpc_id
}
output "pub_sub" {
  value = module.my_vpc.pub_sub
}
output "priweb" {
  value = module.my_vpc.pri_sub_web
}
output "prirds" {
  value = module.my_vpc.pri_sub_rds
}
output "private_rds_cidr" {
   value = module.my_vpc.pri_rds_cidr
 }
