resource "aws_subnet" "front-subnet" {
  vpc_id                  = "vpc-09dbc501dd9b1e577"
  cidr_block              = "172.31.64.0/20"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"
  tags = {
    Name = "front-subnet"
  }
}
resource "aws_route_table" "front-route" {
  vpc_id = "vpc-09dbc501dd9b1e577"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0793b7264d4417a91"
  }
  tags = {
    Name = "front-route"
  }
}
resource "aws_route_table_association" "front-route-association" {
  subnet_id      = aws_subnet.front-subnet.id
  route_table_id = aws_route_table.front-route.id
}

resource "aws_elb" "elb-front" {
  name            = "elb-front"
  security_groups = [aws_security_group.back.id]
  subnets         = [aws_subnet.front-subnet.id]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 5
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
}

resource "aws_launch_configuration" "frontend-config" {
  image_id        = "ami-02b01316e6e3496d9"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.back.name]
  user_data = templatefile("${path.module}/deployment_scripts/frontend.tpl", {
    backend_url = "http://${aws_elb.elb-back.dns_name}:80"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "frontend-instance" {
  availability_zones = ["eu-west-3a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  load_balancers = [aws_elb.elb-front.name]

  launch_configuration = aws_launch_configuration.frontend-config.id
}
