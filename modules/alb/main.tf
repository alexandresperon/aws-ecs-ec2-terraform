resource "aws_security_group" "alb" {
  description = "security-group-${var.alb_name}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = var.allow_cidr_block
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  name = "security-group-${var.alb_name}"

  tags = {
    Env  = var.environment
    Name = "security-group-${var.alb_name}"
  }

  vpc_id = var.vpc_id
}

resource "aws_alb" "default" {
  name            = var.alb_name
  security_groups = [aws_security_group.alb.id]

  subnets = var.public_subnet_ids
}
