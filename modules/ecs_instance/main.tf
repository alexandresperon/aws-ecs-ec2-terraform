data "aws_ami" "default" {
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  most_recent = true
  owners      = ["amazon"]
}

resource "aws_security_group" "ec2" {
  description = "SG for ${var.instance_group}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port       = 32768
    protocol        = "tcp"
    security_groups = [var.alb_security_group]
    to_port         = 65535
  }

  name = "${var.environment}_${var.cluster}_${var.instance_group}"

  tags = {
    Cluster       = var.cluster
    Environment   = var.environment
    InstanceGroup = var.instance_group
  }

  vpc_id = var.vpc_id
}

resource "aws_launch_configuration" "default" {
  name_prefix                 = "${var.environment}_${var.cluster}_${var.instance_group}_"
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile
  image_id                    = var.aws_ami != "" ? var.aws_ami : data.aws_ami.default.id
  instance_type               = var.instance_type
  key_name                    = var.key_name

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
  }

  security_groups = [aws_security_group.ec2.id]
  user_data       = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    ecs_config        = var.ecs_config
    ecs_logging       = var.ecs_logging
    cluster_name      = var.cluster
    env_name          = var.environment
    custom_userdata   = var.custom_userdata
    cloudwatch_prefix = var.cloudwatch_prefix
  }
}
