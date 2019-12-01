provider "aws" {
    region = "eu-east-1"
}

data "aws_ami" "latest-amazon-linux2" {
    most_recent = true
    owners = ["137112412989"] # Amazon
    
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*"]
    }
   
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    
    filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "http_server" {
  #ami = "ami-0c6b1d09930fac512"
  ami = "${data.aws_ami.latest-amazon-linux2.id}"
  #instance_type = "t2.micro"
  instance_type = "${var.instance_flavor}"

  tags = {
    Name = "http_server"
  }
}

output "http_server_public_hostname" {
  value = "${aws_instance.http_server.public_dns}"
}
