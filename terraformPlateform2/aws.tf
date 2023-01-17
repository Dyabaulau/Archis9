terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = "eu-west-3"
}

data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_vpc" "backend_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "front" {
  name        = "backend"
  description = "Controls access to the backend instances"
  vpc_id      = aws_vpc.backend_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "key_name" {
  default = ""
}

resource "aws_launch_template" "front" {
  name          = "backend-template"
  image_id      = data.aws_ami.amazon_ami.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [
    aws_security_group.front.id,
  ]

  user_data = base64encode(templatefile("${path.root}/deployment_scripts/backend.tpl", {}))
}
