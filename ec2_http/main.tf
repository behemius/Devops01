provider "aws" {
    region = "eu-east-1"
}

data "aws_ami" "latest-amazon-linux2" {
    most_recent = true
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*"]
    }
   
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
