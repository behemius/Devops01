provider "aws" {
  region = "eu-central-1"
}

data "aws_ami" "latest-amazon-linux2" {
  most_recent = true
  owners = ["137112412989"] # Amazon

  filter {
    name   = "name"
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
  ami  = data.aws_ami.latest-amazon-linux2.id
  instance_type = "t2.micro"

  tags = {
    Name = "http_server"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install apache2 -y",
      "sudo systemctl enable apache2",
      "sudo systemctl start apache2",
      "sudo chmod 777 /var/www/html/index.html"
    ]
  }

  provisioner "file" {
    source = "index.html"
    destination = "/var/www/html/index.html"
  }
    
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 644 /var/www/html/index.html"
    ]
  }
}

resource "aws_security_group" "http_server" {
  name = "http_server"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "http_server_public_hostname" {
  value = aws_instance.http_server.public_dns
}

output "http_server_public_ip" {
  value = aws_instance.http_server.public_ip
}