variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "az" {
  default = "us-east-1a"
}
variable "allow_all" {
  default = "0.0.0.0/0"
}