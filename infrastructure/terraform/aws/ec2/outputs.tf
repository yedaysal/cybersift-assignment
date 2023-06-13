output "aws_ami_name" {
  description = "The name of the ami"
  value = data.aws_ami.ubuntu.name
}
