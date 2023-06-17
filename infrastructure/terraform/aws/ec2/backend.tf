terraform {
  backend "s3" {
    bucket = "cybersift-terraform-state"
    key = "terraform/eu-central-1-frankfurt/ec2"
    region = "eu-central-1"
    profile = "admin"
    session_name = "Dev"
  }
}