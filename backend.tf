terraform {
  backend "s3" {
    bucket         = "jahnavi-terra-bucket"
    key            = "ec2/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lock_table = true
  }
}