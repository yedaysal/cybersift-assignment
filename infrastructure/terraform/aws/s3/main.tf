resource "aws_s3_bucket" "cybersift" {
  bucket = "cybersift-terraform-state"
  force_destroy = true

  tags = {
    Name        = "CyberSift Terraform State"
    Environment = "Dev"
  }
}