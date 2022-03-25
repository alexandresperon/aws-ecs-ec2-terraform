resource "aws_alb_listener" "default" {
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type             = "forward"
  }

  load_balancer_arn = var.load_balancer
  port              = var.exposed_port
  protocol          = var.protocol
  certificate_arn   = var.certificate_arn
}

resource "aws_alb_target_group" "default" {
  health_check {
    path     = "/"
    protocol = var.protocol
  }

  name     = "alb-target-group"
  port     = var.container_port
  protocol = var.protocol

  stickiness {
    type = "lb_cookie"
  }

  vpc_id = var.vpc_id
}

resource "aws_autoscaling_group" "default" {
  desired_capacity     = var.desired_capacity
  health_check_type    = "EC2"
  launch_configuration = var.launch_configuration
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.service_name}-asg-${var.environment}"

  tag {
    key                 = "Env"
    propagate_at_launch = true
    value               = var.environment
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = var.service_name
  }

  target_group_arns    = [aws_alb_target_group.default.arn]
  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = var.asg_subnets
}

resource "aws_ecs_service" "default" {
  cluster                 = var.cluster
  desired_count           = var.desired_count
  enable_ecs_managed_tags = true
  force_new_deployment    = true

  load_balancer {
    target_group_arn = aws_alb_target_group.default.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  name            = var.service_name
  task_definition = "${aws_ecs_task_definition.default.family}:${data.aws_ecs_task_definition.default.revision}"
}

data "aws_ecs_task_definition" "default" {
  task_definition = aws_ecs_task_definition.default.family
}

resource "aws_ecs_task_definition" "default" {
  container_definitions = templatefile("${path.module}/templates/container_definitions.tftpl", {
    aws_region        = var.aws_region
    container_name    = var.container_name
    container_port    = var.container_port
    image             = var.image
    entry_point       = var.entry_point
    mount_points      = var.mount_points
    environment_vars  = var.environment_vars
    cloudwatch_prefix = var.cloudwatch_prefix
  })

  dynamic "volume" {
    for_each = var.volume
    content {
      name      = volume.value["name"]
      host_path = volume.value["host_path"]
    }
  }

  family                   = "fm-${var.service_name}"
  memory                   = var.task_memory
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
}
