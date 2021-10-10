data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210813.1-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "web" {
  name_prefix                 = var.service_name
  image_id                    = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  user_data                   = file("${path.module}/templates/bootstrap.sh")
  associate_public_ip_address = true

  security_groups      = [aws_security_group.allow_http.id]
  iam_instance_profile = aws_iam_instance_profile.web.id
  enable_monitoring    = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name = var.service_name

  desired_capacity = 2
  max_size         = 2
  min_size         = 2

  vpc_zone_identifier = var.subnet_ids

  launch_configuration = aws_launch_configuration.web.name

  load_balancers = [
    aws_elb.web.id
  ]

  tag {
    key                 = "Name"
    value               = var.service_name
    propagate_at_launch = true
  }

}

resource "aws_elb" "web" {
  name = var.service_name
  security_groups = [
    aws_security_group.allow_http.id
  ]

  subnets                   = var.subnet_ids
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
