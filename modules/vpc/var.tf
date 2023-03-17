variable "vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"

}
variable "public_cidr" {
  type    = list(any)
  default = ["192.168.1.0/24", "192.168.2.0/24"]

}
variable "private_cidr" {
  type    = list(any)
  default = ["192.168.3.0/24", "192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]

}
variable "AZ" {
  type    = list(any)
  default = ["eu-west-1a", "eu-west-1b"]
}
variable "vpc_id" {}