resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${format("%s-%s", "vpc", var.env)}"
    Env = "${var.env}"
  }
}

resource "aws_subnet" "pubnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"

  tags {
    Name = "${format("%s-%s", "pubnet1", var.env)}"
    Env = "${var.env}"
  }
}

resource "aws_subnet" "pubnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1b"

  tags {
    Name = "${format("%s-%s", "pubnet2", var.env)}"
    Env = "${var.env}"
  }
}

resource "aws_subnet" "pubnet3" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1c"

  tags {
    Name = "${format("%s-%s", "pubnet3", var.env)}"
    Env = "${var.env}"
  }
}

resource "aws_subnet" "privnet1" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.11.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1a"

  tags {
    Name = "${format("%s-%s", "privnet1", var.env)}"
    Env = "${var.env}"
  }
}

resource "aws_subnet" "privnet2" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.12.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1b"

  tags {
    Name = "${format("%s-%s", "privnet2", var.env)}"
    Env = "${var.env}"
  }
}

resource "aws_subnet" "privnet3" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.13.0/24"
  map_public_ip_on_launch = false
  availability_zone = "eu-west-1c"

  tags {
    Name = "${format("%s-%s", "privnet3", var.env)}"
    Env = "${var.env}"
  }
}

