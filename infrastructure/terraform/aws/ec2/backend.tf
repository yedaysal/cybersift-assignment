terraform {
  backend "s3" {
    bucket = "cybersift-terraform-state"
    key = "terraform/eu-central-1-frankfurt/ec2"
    region = "eu-central-1"
    profile = "AWS_CONFIG_PROFILE_NAME"
    session_name = "Dev"
  }
}