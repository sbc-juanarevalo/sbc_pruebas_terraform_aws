provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "instance1" {
    ami = "ami-0889a44b331db0194"
    instance_type = "t1.micro"
    tags = {
      "name" = "first_instance"
    }
}