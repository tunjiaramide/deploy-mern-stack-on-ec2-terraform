terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

# input the region you want to deploy the application
provider "aws" {
  region = "us-east-1"
}


# Open up port 80, 22, 5000 for the MERN applications
resource "aws_security_group" "mern_sg" {
  name        = "mern-sg"
  description = "Allow SSH, HTTP, react and node ports"

  ingress {
    description = "Port 80 for ngnix"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 22 for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 5000 for backend"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ports_mern"
  }
}

# Create a web server and attach the SG created
resource "aws_instance" "web_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.mern_sg.id]
  user_data              = file("install.tpl") # Bash script to install the application

  tags = {
    Name = "MERN Server"
  }
}

# server public IP
output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public address of the IP"
}
