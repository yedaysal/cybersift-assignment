resource "aws_s3_bucket" "cybersift" {
  bucket = "cybersift-terraform-state"

  tags = {
    Name        = "CyberSift Terraform State"
    Environment = "Dev"
  }
}