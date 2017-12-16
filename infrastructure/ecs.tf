###################
### ECS CLUSTER ###
###################

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.env}"
}

###############
### ECS IAM ###
###############

resource "aws_iam_role_policy" "ecs-instance-policy" {
  name   = "${format("%s-%s", "ecs-instance-policy", var.env)}"
  role   = "${aws_iam_role.ecs-instance-role.id}"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
}

resource "aws_iam_role" "ecs-instance-role" {
  name               = "${format("%s-%s", "ecs-instance-role", var.env)}"
  assume_role_policy = "${file("policies/ecs-instance-role.json")}"
}

resource "aws_iam_role_policy" "ecs-service-policy" {
  name   = "${format("%s-%s", "ecs-service-policy", var.env)}"
  role   = "${aws_iam_role.ecs-service-role.id}"
  policy = "${file("policies/ecs-service-role-policy.json")}"
}

resource "aws_iam_role" "ecs-service-role" {
  name               = "${format("%s-%s", "ecs-service-role", var.env)}"
  assume_role_policy = "${file("policies/ecs-service-role.json")}"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "${format("%s-%s", "ecs-instance-profile", var.env)}"
  role = "${aws_iam_role.ecs-instance-role.id}"
}

###############
### ECS ASG ###
###############

data "aws_ami" "ecs-optimized" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-2017.*.g-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] # Amazon
}

resource "aws_launch_configuration" "asg-conf-ecs" {
  image_id                    = "${data.aws_ami.ecs-optimized.id}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.hackathon-master.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-profile.id}"
  security_groups             = ["${aws_security_group.sg-ecs.id}"]
  user_data                   = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs-cluster.name} > /etc/ecs/ecs.config"
  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp2"
    volume_size = 15
  }

  ebs_block_device {
    device_name = "/dev/xvdcz"
    volume_type = "gp2"
    volume_size = 25
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-ecs" {
  vpc_zone_identifier  = ["${aws_subnet.privnet1.id}", "${aws_subnet.privnet2.id}", "${aws_subnet.privnet3.id}"]
  launch_configuration = "${aws_launch_configuration.asg-conf-ecs.name}"
  min_size             = 1
  max_size             = 2
  desired_capacity     = 2

  lifecycle {
    create_before_destroy = true
  }

  tag = [
    {
      "key"                 = "Name"
      "value"               = "${format("%s %s", "ECS instance", var.env)}"
      "propagate_at_launch" = true
    },
  ]
}

###############
### OUTPUTS ###
###############

output "ecs-cluster-id" {
  value = "${aws_ecs_cluster.ecs-cluster.id}"
}

output "ecs-service-role-id" {
  value = "${aws_iam_role.ecs-service-role.id}"
}
