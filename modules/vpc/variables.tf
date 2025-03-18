variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
/*variable "private_subnet_cidr" {}*/
variable "az" {
  default = "us-east-1a"
}
variable "az2" {
  default = "us-east-1b"
}
variable "allow_all" {
  default = "0.0.0.0/0"
}
variable "public_subnet_2_cidr" {
  default = "10.0.3.0/24"
}