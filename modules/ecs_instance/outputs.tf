output "ecs_instance_security_group_id" {
  value = aws_security_group.ec2.id
}

output "launch_configuration_id" {
  value = aws_launch_configuration.default.id
}
