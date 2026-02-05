terraform {
  backend "s3" {
    bucket         = "s3terrasgitlabsmy01"
    key            = "sandbox/ec2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
