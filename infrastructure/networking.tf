###########
### VPC ###
###########

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${format("%s-%s", "vpc", var.env)}"
    Env  = "${var.env}"
  }
}

########################
### INTERNET DEVICES ###
########################

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${format("%s-%s", "ig", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat-gateway1-eip.id}"
  subnet_id     = "${aws_subnet.pubnet1.id}"
}

######################
### PUBLIC SUBNETS ###
######################

resource "aws_subnet" "pubnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags {
    Name = "${format("%s-%s", "pubnet1", var.env)}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "pubnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"

  tags {
    Name = "${format("%s-%s", "pubnet2", var.env)}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "pubnet3" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1c"

  tags {
    Name = "${format("%s-%s", "pubnet3", var.env)}"
    Env  = "${var.env}"
  }
}

#######################
### PRIVATE SUBNETS ###
#######################

resource "aws_subnet" "privnet1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1a"

  tags {
    Name = "${format("%s-%s", "privnet1", var.env)}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "privnet2" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1b"

  tags {
    Name = "${format("%s-%s", "privnet2", var.env)}"
    Env  = "${var.env}"
  }
}

resource "aws_subnet" "privnet3" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.13.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-west-1c"

  tags {
    Name = "${format("%s-%s", "privnet3", var.env)}"
    Env  = "${var.env}"
  }
}

#############################
### ROUTE TABLES - PUBLIC ###
#############################

resource "aws_route_table" "rt-public1" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"
  }

  tags {
    Name        = "${format("%s-%s", "rt-public1", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_route_table_association" "rt-asso-public1" {
  subnet_id      = "${aws_subnet.pubnet1.id}"
  route_table_id = "${aws_route_table.rt-public1.id}"
}

resource "aws_route_table_association" "rt-asso-public2" {
  subnet_id      = "${aws_subnet.pubnet2.id}"
  route_table_id = "${aws_route_table.rt-public1.id}"
}

resource "aws_route_table_association" "rt-asso-public3" {
  subnet_id      = "${aws_subnet.pubnet3.id}"
  route_table_id = "${aws_route_table.rt-public1.id}"
}

##############################
### ROUTE TABLES - PRIVATE ###
##############################

resource "aws_route_table" "rt-private1" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags {
    Name        = "${format("%s-%s", "rt-private1", var.env)}"
    Environment = "${var.env}"
  }
}

resource "aws_route_table_association" "rt-asso-private1" {
  subnet_id      = "${aws_subnet.privnet1.id}"
  route_table_id = "${aws_route_table.rt-private1.id}"
}

resource "aws_route_table_association" "rt-asso-private2" {
  subnet_id      = "${aws_subnet.privnet2.id}"
  route_table_id = "${aws_route_table.rt-private1.id}"
}

resource "aws_route_table_association" "rt-asso-private3" {
  subnet_id      = "${aws_subnet.privnet3.id}"
  route_table_id = "${aws_route_table.rt-private1.id}"
}

###################
### ELASTIC IPS ###
###################

resource "aws_eip" "nat-gateway1-eip" {
  vpc = true
}

###############
### OUTPUTS ###
###############

output "vpc-id" {
  value = "${aws_vpc.vpc.id}"
}

output "pubnet1-id" {
  value = "${aws_subnet.pubnet1.id}"
}

output "pubnet2-id" {
  value = "${aws_subnet.pubnet2.id}"
}

output "pubnet3-id" {
  value = "${aws_subnet.pubnet3.id}"
}

output "privnet1-id" {
  value = "${aws_subnet.privnet1.id}"
}

output "privnet2-id" {
  value = "${aws_subnet.privnet2.id}"
}

output "privnet3-id" {
  value = "${aws_subnet.privnet3.id}"
}
