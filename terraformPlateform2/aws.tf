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

resource "aws_security_group" "back" {
  name        = "backend"
  description = "Controls access to the backend instances"

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

resource "aws_launch_configuration" "backend-config" {
  image_id        = "ami-02b01316e6e3496d9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.back.name]
  user_data = templatefile("${path.module}/deployment_scripts/backend.tpl", {
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend-instance" {
  availability_zones = ["eu-west-3a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_configuration = aws_launch_configuration.backend-config.id
}
