resource "aws_ecs_cluster" "cluster" {
  lifecycle {
    create_before_destroy = true
  }

  name = var.cluster_name

  tags = {
    Name = var.cluster_name
  }
}
